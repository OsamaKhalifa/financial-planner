import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/ai_providers.dart';
import 'package:financial_planner/core/ai/ai_settings.dart';
import 'package:financial_planner/core/ai/ai_vendors.dart';
import 'package:financial_planner/core/ai/gemini_ai_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_client.dart';
import '../../support/fake_ai_vendor.dart';

void main() {
  const prompt = AiPrompt(instruction: 'i', input: 'x');

  Future<AiClient> clientFor(
    Map<String, String> stored, {
    List<Override> overrides = const [],
  }) async {
    FlutterSecureStorage.setMockInitialValues(stored);
    final container = ProviderContainer.test(overrides: overrides);
    await container.read(aiSettingsProvider.future);
    return container.read(aiClientProvider);
  }

  test('off by default, even with a vendor and its key', () async {
    final client = await clientFor({
      'ai.vendor': 'gemini',
      'ai.apiKey.gemini': 'k',
    });

    await expectLater(client.complete(prompt), throwsA(isA<AiUnavailable>()));
  });

  test('on with no provider picked is unavailable', () async {
    final client = await clientFor({'ai.cloudEnabled': 'true'});

    await expectLater(client.complete(prompt), throwsA(isA<AiUnavailable>()));
  });

  test('on with a vendor and its key uses that vendor', () async {
    final client = await clientFor({
      'ai.cloudEnabled': 'true',
      'ai.vendor': 'gemini',
      'ai.apiKey.gemini': 'k',
    });

    expect(client, isA<GeminiAiClient>());
  });

  test('on with a vendor but no key is unavailable', () async {
    final client = await clientFor({
      'ai.cloudEnabled': 'true',
      'ai.vendor': 'gemini',
    });

    await expectLater(client.complete(prompt), throwsA(isA<AiUnavailable>()));
  });

  test('a newly added vendor works with no other change', () async {
    final client = await clientFor(
      {
        'ai.cloudEnabled': 'true',
        'ai.vendor': 'fakeai',
        'ai.apiKey.fakeai': 'k',
      },
      overrides: [
        aiVendorsProvider.overrideWithValue([...defaultAiVendors, fakeVendor]),
      ],
    );

    expect((await client.complete(prompt)).text, 'from fake vendor');
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
