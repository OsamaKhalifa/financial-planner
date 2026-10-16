import 'dart:async';
import 'dart:convert';

import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/cloud_ai_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const prompt = AiPrompt(instruction: 'Be brief.', input: 'Hello');

  CloudAiClient clientWith(MockClientHandler handler,
          {Duration timeout = const Duration(seconds: 5)}) =>
      CloudAiClient(
        httpClient: MockClient(handler),
        proxyUrl: Uri.parse('https://proxy.example.dev'),
        appToken: 'token-1',
        timeout: timeout,
      );

  test('sends the neutral request and returns the text', () async {
    late http.Request sent;
    final client = clientWith((request) async {
      sent = request;
      return http.Response(jsonEncode({'text': 'Hi'}), 200);
    });

    final reply = await client.complete(prompt);

    expect(reply.text, 'Hi');
    expect(sent.method, 'POST');
    expect(sent.url.toString(), 'https://proxy.example.dev/v1/complete');
    expect(sent.headers['x-app-token'], 'token-1');
    expect(jsonDecode(sent.body), {
      'instruction': 'Be brief.',
      'input': 'Hello',
      'maxOutputTokens': 1024,
    });
  });

  test('429 becomes AiQuotaExceeded with retry-after', () async {
    final client = clientWith((_) async =>
        http.Response('', 429, headers: {'retry-after': '30'}));

    await expectLater(
      client.complete(prompt),
      throwsA(isA<AiQuotaExceeded>().having(
          (e) => e.retryAfter, 'retryAfter', const Duration(seconds: 30))),
    );
  });

  test('server error becomes AiFailure', () async {
    final client = clientWith((_) async => http.Response('boom', 500));

    await expectLater(client.complete(prompt), throwsA(isA<AiFailure>()));
  });

  test('unexpected body becomes AiFailure', () async {
    for (final body in ['not json', '{"answer":"x"}', '{"text":3}']) {
      final client = clientWith((_) async => http.Response(body, 200));

      await expectLater(client.complete(prompt), throwsA(isA<AiFailure>()),
          reason: body);
    }
  });

  test('network error becomes AiFailure', () async {
    final client =
        clientWith((_) async => throw http.ClientException('offline'));

    await expectLater(client.complete(prompt), throwsA(isA<AiFailure>()));
  });

  test('timeout becomes AiFailure', () async {
    final client = clientWith((_) => Completer<http.Response>().future,
        timeout: const Duration(milliseconds: 10));

    await expectLater(client.complete(prompt), throwsA(isA<AiFailure>()));
  });
}
