import 'package:financial_planner/core/ai/ai_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('defaults to off with no key', () async {
    final settings = await ProviderContainer.test().read(
      aiSettingsProvider.future,
    );

    expect(settings.cloudEnabled, isFalse);
    expect(settings.ownGeminiKey, isNull);
  });

  test('saved values survive a restart', () async {
    final first = ProviderContainer.test();
    await first.read(aiSettingsProvider.future);
    await first.read(aiSettingsProvider.notifier).setCloudEnabled(true);
    await first.read(aiSettingsProvider.notifier).setOwnGeminiKey('  k-1  ');

    final settings = await ProviderContainer.test().read(
      aiSettingsProvider.future,
    );

    expect(settings.cloudEnabled, isTrue);
    expect(settings.ownGeminiKey, 'k-1');
  });

  test('a blank key removes the saved key', () async {
    FlutterSecureStorage.setMockInitialValues({'ai.ownGeminiKey': 'old'});
    final container = ProviderContainer.test();
    await container.read(aiSettingsProvider.future);

    await container.read(aiSettingsProvider.notifier).setOwnGeminiKey('  ');

    expect(container.read(aiSettingsProvider).value?.ownGeminiKey, isNull);
    expect(
      await const FlutterSecureStorage().read(key: 'ai.ownGeminiKey'),
      isNull,
    );
  });
}
