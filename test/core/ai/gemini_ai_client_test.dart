import 'dart:async';
import 'dart:convert';

import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/gemini_ai_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const prompt = AiPrompt(
    instruction: 'Be brief.',
    input: 'Hello',
    maxOutputTokens: 64,
  );

  GeminiAiClient clientWith(
    MockClientHandler handler, {
    Duration timeout = const Duration(seconds: 5),
  }) => GeminiAiClient(
    httpClient: MockClient(handler),
    apiKey: 'user-key',
    model: 'model-x',
    timeout: timeout,
  );

  String reply(List<Map<String, Object>> parts) => jsonEncode({
    'candidates': [
      {
        'content': {'parts': parts},
      },
    ],
  });

  test('sends the Gemini request with the key in a header', () async {
    late http.Request sent;
    final client = clientWith((request) async {
      sent = request;
      return http.Response(
        reply([
          {'text': 'Hi'},
          {'thought': true},
          {'text': '!'},
        ]),
        200,
      );
    });

    final result = await client.complete(prompt);

    expect(result.text, 'Hi!');
    expect(
      sent.url.toString(),
      'https://generativelanguage.googleapis.com/v1beta/models/model-x:generateContent',
    );
    expect(sent.url.query, isEmpty);
    expect(sent.headers['x-goog-api-key'], 'user-key');
    expect(jsonDecode(sent.body), {
      'systemInstruction': {
        'parts': [
          {'text': 'Be brief.'},
        ],
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': 'Hello'},
          ],
        },
      ],
      'generationConfig': {'maxOutputTokens': 64},
    });
  });

  test('429 becomes AiQuotaExceeded', () async {
    final client = clientWith(
      (_) async => http.Response('', 429, headers: {'retry-after': '7'}),
    );

    await expectLater(
      client.complete(prompt),
      throwsA(
        isA<AiQuotaExceeded>().having(
          (e) => e.retryAfter,
          'retryAfter',
          const Duration(seconds: 7),
        ),
      ),
    );
  });

  test('a rejected key becomes AiUnavailable', () async {
    final responses = [
      http.Response(
        '{"error":{"details":[{"reason":"API_KEY_INVALID"}]}}',
        400,
      ),
      http.Response('', 401),
      http.Response('', 403),
    ];
    for (final response in responses) {
      final client = clientWith((_) async => response);

      await expectLater(
        client.complete(prompt),
        throwsA(isA<AiUnavailable>()),
        reason: '${response.statusCode}',
      );
    }
  });

  test('other errors and empty replies become AiFailure', () async {
    final responses = [
      http.Response('{"error":{}}', 400),
      http.Response('boom', 500),
      http.Response('not json', 200),
      http.Response('{"candidates":[]}', 200),
      http.Response(
        reply([
          {'thought': true},
        ]),
        200,
      ),
    ];
    for (final response in responses) {
      final client = clientWith((_) async => response);

      await expectLater(
        client.complete(prompt),
        throwsA(isA<AiFailure>()),
        reason: response.body,
      );
    }
  });

  test('network error and timeout become AiFailure', () async {
    await expectLater(
      clientWith((_) async => throw http.ClientException('offline'))
          .complete(prompt),
      throwsA(isA<AiFailure>()),
    );
    await expectLater(
      clientWith(
        (_) => Completer<http.Response>().future,
        timeout: const Duration(milliseconds: 10),
      ).complete(prompt),
      throwsA(isA<AiFailure>()),
    );
  });
}
