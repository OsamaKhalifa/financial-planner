import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/ai_providers.dart';
import 'package:financial_planner/core/ai/cloud_ai_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_client.dart';

void main() {
  const prompt = AiPrompt(instruction: 'i', input: 'x');
  final config = AiProxyConfig(
      url: Uri.parse('https://proxy.example.dev'), appToken: 't');

  test('cloud AI is off by default, so calls are unavailable', () async {
    final container = ProviderContainer.test(
        overrides: [aiProxyConfigProvider.overrideWithValue(config)]);

    await expectLater(container.read(aiClientProvider).complete(prompt),
        throwsA(isA<AiUnavailable>()));
  });

  test('switched on but not configured is unavailable', () async {
    final container = ProviderContainer.test(
        overrides: [aiProxyConfigProvider.overrideWithValue(null)]);
    container.read(aiCloudEnabledProvider.notifier).set(true);

    await expectLater(container.read(aiClientProvider).complete(prompt),
        throwsA(isA<AiUnavailable>()));
  });

  test('switched on and configured gives the cloud client', () {
    final container = ProviderContainer.test(
        overrides: [aiProxyConfigProvider.overrideWithValue(config)]);
    container.read(aiCloudEnabledProvider.notifier).set(true);

    expect(container.read(aiClientProvider), isA<CloudAiClient>());
  });

  test('features can swap in a fake without knowing the real client',
      () async {
    final fake = FakeAiClient(reply: 'canned');
    final container = ProviderContainer.test(
        overrides: [aiClientProvider.overrideWithValue(fake)]);

    final reply = await container.read(aiClientProvider).complete(prompt);

    expect(reply.text, 'canned');
    expect(fake.prompts.single.input, 'x');
  });
}
