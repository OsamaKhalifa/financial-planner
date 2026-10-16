import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'ai_vendors.dart';

class AiSettings {
  const AiSettings({
    this.cloudEnabled = false,
    this.vendorId,
    this.apiKeys = const {},
  });

  /// The user's opt-in. Off by default: data stays on the device.
  final bool cloudEnabled;

  /// Null means the app's shared AI service. Otherwise the [AiVendor.id] the
  /// user brings their own key for.
  final String? vendorId;

  /// One key per vendor, so switching vendor keeps the other keys.
  final Map<String, String> apiKeys;

  String? get apiKey => apiKeys[vendorId];
}

/// Secure storage because API keys are secrets. Settings never move to a
/// server, so no repository interface (ADR-0001 does not apply).
class AiSettingsStore {
  const AiSettingsStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _cloudEnabledKey = 'ai.cloudEnabled';
  static const _vendorKey = 'ai.vendor';
  static String _apiKeyKey(String vendorId) => 'ai.apiKey.$vendorId';

  /// A stored vendor that is no longer offered falls back to the shared
  /// service.
  Future<AiSettings> read(List<String> vendorIds) async {
    final apiKeys = <String, String>{};
    for (final id in vendorIds) {
      final key = await _storage.read(key: _apiKeyKey(id));
      if (key != null) apiKeys[id] = key;
    }
    final vendorId = await _storage.read(key: _vendorKey);
    return AiSettings(
      cloudEnabled: await _storage.read(key: _cloudEnabledKey) == 'true',
      vendorId: vendorIds.contains(vendorId) ? vendorId : null,
      apiKeys: apiKeys,
    );
  }

  Future<void> writeCloudEnabled(bool enabled) =>
      _storage.write(key: _cloudEnabledKey, value: '$enabled');

  Future<void> writeVendor(String? vendorId) => vendorId == null
      ? _storage.delete(key: _vendorKey)
      : _storage.write(key: _vendorKey, value: vendorId);

  Future<void> writeApiKey(String vendorId, String? key) => key == null
      ? _storage.delete(key: _apiKeyKey(vendorId))
      : _storage.write(key: _apiKeyKey(vendorId), value: key);
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
  Future<AiSettings> build() => _store.read([
    for (final vendor in ref.watch(aiVendorsProvider)) vendor.id,
  ]);

  Future<void> setCloudEnabled(bool enabled) async {
    final current = await future;
    await _store.writeCloudEnabled(enabled);
    state = AsyncData(
      AiSettings(
        cloudEnabled: enabled,
        vendorId: current.vendorId,
        apiKeys: current.apiKeys,
      ),
    );
  }

  /// Null selects the app's shared service.
  Future<void> selectVendor(String? vendorId) async {
    final current = await future;
    await _store.writeVendor(vendorId);
    state = AsyncData(
      AiSettings(
        cloudEnabled: current.cloudEnabled,
        vendorId: vendorId,
        apiKeys: current.apiKeys,
      ),
    );
  }

  /// A null or blank key removes it.
  Future<void> setApiKey(String vendorId, String? key) async {
    final current = await future;
    final trimmed = key?.trim();
    final value = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    await _store.writeApiKey(vendorId, value);
    final apiKeys = {...current.apiKeys};
    value == null ? apiKeys.remove(vendorId) : apiKeys[vendorId] = value;
    state = AsyncData(
      AiSettings(
        cloudEnabled: current.cloudEnabled,
        vendorId: current.vendorId,
        apiKeys: apiKeys,
      ),
    );
  }
}
