import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/ai_providers.dart';
import 'package:financial_planner/core/ai/ai_settings.dart';
import 'package:financial_planner/core/ai/cloud_ai_client.dart';
import 'package:financial_planner/core/ai/gemini_ai_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_client.dart';

void main() {
  const prompt = AiPrompt(instruction: 'i', input: 'x');
  final proxy = AiProxyConfig(
    url: Uri.parse('https://proxy.example.dev'),
    appToken: 't',
  );

  Future<AiClient> clientFor(
    Map<String, String> stored, {
    AiProxyConfig? config,
  }) async {
    FlutterSecureStorage.setMockInitialValues(stored);
    final container = ProviderContainer.test(
      overrides: [aiProxyConfigProvider.overrideWithValue(config)],
    );
    await container.read(aiSettingsProvider.future);
    return container.read(aiClientProvider);
  }

  test('off by default, even with a key and a proxy', () async {
    final client = await clientFor({'ai.ownGeminiKey': 'k'}, config: proxy);

    await expectLater(client.complete(prompt), throwsA(isA<AiUnavailable>()));
  });

  test('on with own key goes straight to Gemini', () async {
    final client = await clientFor({
      'ai.cloudEnabled': 'true',
      'ai.ownGeminiKey': 'k',
    }, config: proxy);

    expect(client, isA<GeminiAiClient>());
  });

  test('on without own key uses the shared proxy', () async {
    final client = await clientFor({'ai.cloudEnabled': 'true'}, config: proxy);

    expect(client, isA<CloudAiClient>());
  });

  test('on with no key and no proxy is unavailable', () async {
    final client = await clientFor({'ai.cloudEnabled': 'true'});

    await expectLater(client.complete(prompt), throwsA(isA<AiUnavailable>()));
  });

  test('features can swap in a fake without knowing the real client', () async {
    final fake = FakeAiClient(reply: 'canned');
    final container = ProviderContainer.test(
      overrides: [aiClientProvider.overrideWithValue(fake)],
    );

    final reply = await container.read(aiClientProvider).complete(prompt);

    expect(reply.text, 'canned');
    expect(fake.prompts.single.input, 'x');
  });
}
