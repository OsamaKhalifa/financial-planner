import 'package:financial_planner/core/ai/ai_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('defaults to off, shared service, no keys', () async {
    final settings = await ProviderContainer.test().read(
      aiSettingsProvider.future,
    );

    expect(settings.cloudEnabled, isFalse);
    expect(settings.vendorId, isNull);
    expect(settings.apiKeys, isEmpty);
  });

  test('saved values survive a restart', () async {
    final first = ProviderContainer.test();
    await first.read(aiSettingsProvider.future);
    final notifier = first.read(aiSettingsProvider.notifier);
    await notifier.setCloudEnabled(true);
    await notifier.selectVendor('gemini');
    await notifier.setApiKey('gemini', '  k-1  ');

    final settings = await ProviderContainer.test().read(
      aiSettingsProvider.future,
    );

    expect(settings.cloudEnabled, isTrue);
    expect(settings.vendorId, 'gemini');
    expect(settings.apiKey, 'k-1');
  });

  test('a blank key removes the saved key', () async {
    FlutterSecureStorage.setMockInitialValues({'ai.apiKey.gemini': 'old'});
    final container = ProviderContainer.test();
    await container.read(aiSettingsProvider.future);

    await container.read(aiSettingsProvider.notifier).setApiKey('gemini', ' ');

    expect(container.read(aiSettingsProvider).value?.apiKeys, isEmpty);
    expect(
      await const FlutterSecureStorage().read(key: 'ai.apiKey.gemini'),
      isNull,
    );
  });

  test('a vendor no longer offered falls back to the shared service', () async {
    FlutterSecureStorage.setMockInitialValues({
      'ai.vendor': 'gone',
      'ai.apiKey.gone': 'k',
    });

    final settings = await ProviderContainer.test().read(
      aiSettingsProvider.future,
    );

    expect(settings.vendorId, isNull);
    expect(settings.apiKeys, isEmpty);
  });
}
