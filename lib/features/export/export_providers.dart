/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/assumptions/assumptions_providers.dart';
import '../../core/assumptions/data/rate_refresher.dart';
import '../../core/clock_provider.dart';
import '../../l10n/app_localizations_en.dart';
import '../investments/presentation/investments_providers.dart';
import 'data/google_sheets_client.dart';
import 'export_tables.dart';

/// OAuth client ids from Google Cloud (ADR-0007). Not secrets: they ship in
/// the app. iOS also needs the reversed iOS id in GoogleSignIn.xcconfig.
const googleIosClientId = '';
const googleServerClientId = '';

/// The linked account's email; null when none is linked.
final googleAccountProvider =
    AsyncNotifierProvider<GoogleAccountNotifier, String?>(
      GoogleAccountNotifier.new,
    );

class GoogleAccountNotifier extends AsyncNotifier<String?> {
  static const _scopes = [GoogleSheetsClient.scope];

  // initialize must run exactly once per app run.
  static Future<void>? _initialized;

  GoogleSignInAccount? _account;

  GoogleSignIn get _signIn => GoogleSignIn.instance;

  /// Without its client id the iOS SDK throws a native exception that kills
  /// the app, so sign-in is never called then.
  static bool get _configured => defaultTargetPlatform == TargetPlatform.iOS
      ? googleIosClientId.isNotEmpty
      : googleServerClientId.isNotEmpty;

  Future<void> _ready() => _initialized ??= _signIn.initialize(
    clientId: googleIosClientId.isEmpty ? null : googleIosClientId,
    serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
  );

  /// Restores an earlier link without UI.
  @override
  Future<String?> build() async {
    if (!_configured) return null;
    try {
      await _ready();
      _account = await _signIn.attemptLightweightAuthentication();
    } on GoogleSignInException {
      _account = null;
    }
    return _account?.email;
  }

  /// Does nothing when the user cancels. Throws [ExportFailed].
  Future<void> link() async {
    if (!_configured) {
      throw const ExportFailed('Google sign-in is not set up in this build.');
    }
    try {
      await _ready();
      _account = await _signIn.authenticate(scopeHint: _scopes);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      throw ExportFailed(
        'Google sign-in failed: ${e.description ?? e.code.name}',
      );
    }
    state = AsyncData(_account!.email);
  }

  /// Also revokes the app's access, so the next link asks again.
  Future<void> unlink() async {
    await _signIn.disconnect();
    _account = null;
    state = const AsyncData(null);
  }

  /// Shows Google's consent sheet only when the user has not granted it yet.
  Future<String> accessToken() async {
    final account = _account;
    if (account == null) {
      throw const ExportFailed('Link a Google account first.');
    }
    final client = account.authorizationClient;
    try {
      final auth =
          await client.authorizationForScopes(_scopes) ??
          await client.authorizeScopes(_scopes);
      return auth.accessToken;
    } on GoogleSignInException catch (e) {
      throw ExportFailed(
        e.code == GoogleSignInExceptionCode.canceled
            ? 'Export needs access to your Google Drive.'
            : 'Google sign-in failed: ${e.description ?? e.code.name}',
      );
    }
  }

  /// After Google refused [token]; the next [accessToken] gets a fresh one.
  Future<void> forgetToken(String token) async =>
      _account?.authorizationClient.clearAuthorizationToken(accessToken: token);
}

sealed class ExportState {
  const ExportState();
}

final class ExportIdle extends ExportState {
  const ExportIdle();
}

final class ExportRunning extends ExportState {
  const ExportRunning(this.mode);

  final ExportMode mode;
}

final class ExportDone extends ExportState {
  const ExportDone(this.url);

  final Uri url;
}

final class ExportError extends ExportState {
  const ExportError(this.message);

  final String message;
}

/// The only path that sends user data to Google, and only on a tap.
class ExportController extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportIdle();

  Future<void> run(ExportMode mode) async {
    if (state is ExportRunning) return;
    state = ExportRunning(mode);
    try {
      final data = ExportData(
        items: await _read(investmentsProvider.future),
        rates: await _read(ratesProvider.future),
        inflationOverrides: await _read(inflationOverridesProvider.future),
        settings: await _read(settingsProvider.future),
        noZakatYears: await _read(noZakatYearsProvider.future),
        calculator: mode == ExportMode.snapshot
            ? await _read(calculatorProvider.future)
            : null,
      );
      final tabs = exportTables(data, mode, AppLocalizationsEn());
      final now = cellText(ref.read(clockProvider)());
      final name = mode == ExportMode.full ? 'Full' : 'Snapshot';
      state = ExportDone(
        await _create('Financial Planner — $name — $now', tabs),
      );
    } on ExportFailed catch (e) {
      state = ExportError(e.message);
    }
  }

  /// Listens while reading: a provider no screen watches is paused and its
  /// future would never complete.
  Future<T> _read<T>(ProviderListenable<Future<T>> provider) async {
    final sub = ref.listen(provider, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  /// One retry with a fresh token: a cached one can be expired or revoked.
  Future<Uri> _create(String title, List<SheetTab> tabs) async {
    final account = ref.read(googleAccountProvider.notifier);
    for (var attempt = 0; ; attempt++) {
      final token = await account.accessToken();
      try {
        return await GoogleSheetsClient(
          httpClient: ref.read(httpClientProvider),
          accessToken: token,
        ).create(title, tabs);
      } on ExportAuthFailed {
        await account.forgetToken(token);
        if (attempt == 1) {
          throw const ExportFailed(
            'Google did not accept the sign-in. Unlink and link again.',
          );
        }
      }
    }
  }
}

final exportControllerProvider =
    NotifierProvider<ExportController, ExportState>(ExportController.new);
