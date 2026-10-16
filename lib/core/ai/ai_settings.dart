import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AiSettings {
  const AiSettings({this.cloudEnabled = false, this.ownGeminiKey});

  /// The user's opt-in. Off by default: data stays on the device.
  final bool cloudEnabled;

  /// When set, requests go straight to Google with this key instead of
  /// through the app's shared proxy.
  final String? ownGeminiKey;
}

/// Secure storage because the Gemini key is a secret. Settings never move to
/// a server, so no repository interface (ADR-0001 does not apply).
class AiSettingsStore {
  const AiSettingsStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _cloudEnabledKey = 'ai.cloudEnabled';
  static const _ownGeminiKeyKey = 'ai.ownGeminiKey';

  Future<AiSettings> read() async => AiSettings(
    cloudEnabled: await _storage.read(key: _cloudEnabledKey) == 'true',
    ownGeminiKey: await _storage.read(key: _ownGeminiKeyKey),
  );

  Future<void> writeCloudEnabled(bool enabled) =>
      _storage.write(key: _cloudEnabledKey, value: '$enabled');

  Future<void> writeOwnGeminiKey(String? key) => key == null
      ? _storage.delete(key: _ownGeminiKeyKey)
      : _storage.write(key: _ownGeminiKeyKey, value: key);
}

final aiSettingsStoreProvider = Provider<AiSettingsStore>(
  (ref) => const AiSettingsStore(FlutterSecureStorage()),
);

final aiSettingsProvider =
    AsyncNotifierProvider<AiSettingsNotifier, AiSettings>(
      AiSettingsNotifier.new,
    );

class AiSettingsNotifier extends AsyncNotifier<AiSettings> {
  AiSettingsStore get _store => ref.read(aiSettingsStoreProvider);

  @override
  Future<AiSettings> build() => _store.read();

  Future<void> setCloudEnabled(bool enabled) async {
    final current = await future;
    await _store.writeCloudEnabled(enabled);
    state = AsyncData(
      AiSettings(cloudEnabled: enabled, ownGeminiKey: current.ownGeminiKey),
    );
  }

  /// A null or blank key removes it.
  Future<void> setOwnGeminiKey(String? key) async {
    final current = await future;
    final trimmed = key?.trim();
    final value = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    await _store.writeOwnGeminiKey(value);
    state = AsyncData(
      AiSettings(cloudEnabled: current.cloudEnabled, ownGeminiKey: value),
    );
  }
}
