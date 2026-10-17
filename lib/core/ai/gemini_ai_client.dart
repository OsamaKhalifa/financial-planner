import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_client.dart';

/// Calls Gemini directly with the user's own key.
class GeminiAiClient implements AiClient {
  GeminiAiClient({
    required http.Client httpClient,
    required this._apiKey,
    this._model = defaultModel,
    this._timeout = const Duration(seconds: 30),
    this._retryDelay = const Duration(seconds: 1),
  }) : _http = httpClient;

  static const defaultModel = String.fromEnvironment(
    'AI_GEMINI_MODEL',
    defaultValue: 'gemini-flash-lite-latest',
  );

  final http.Client _http;
  final String _apiKey;
  final String _model;
  final Duration _timeout;
  final Duration _retryDelay;

  @override
  Future<AiReply> complete(AiPrompt prompt) async {
    var response = await _send(prompt);
    // 503 = Gemini overloaded ("high demand"); it usually clears in a second.
    if (response.statusCode == 503) {
      await Future<void>.delayed(_retryDelay);
      response = await _send(prompt);
    }
    return _parse(response);
  }

  Future<http.Response> _send(AiPrompt prompt) async {
    try {
      return await _http
          .post(
            Uri.https(
              'generativelanguage.googleapis.com',
              '/v1beta/models/$_model:generateContent',
            ),
            // Header, never a query parameter: URLs end up in logs.
            headers: {
              'content-type': 'application/json',
              'x-goog-api-key': _apiKey,
            },
            body: jsonEncode({
              'systemInstruction': {
                'parts': [
                  {'text': prompt.instruction},
                ],
              },
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': prompt.input},
                  ],
                },
              ],
              'generationConfig': {'maxOutputTokens': prompt.maxOutputTokens},
            }),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AiFailure('AI request timed out.');
    } on http.ClientException catch (e) {
      throw AiFailure('AI request failed: ${e.message}');
    }
  }

  AiReply _parse(http.Response response) {
    final status = response.statusCode;
    if (status == 429) {
      final seconds = int.tryParse(response.headers['retry-after'] ?? '');
      throw AiQuotaExceeded(
        retryAfter: seconds == null ? null : Duration(seconds: seconds),
      );
    }
    if (status == 401 ||
        status == 403 ||
        (status == 400 && response.body.contains('API_KEY_INVALID'))) {
      throw const AiUnavailable('Gemini rejected your API key.');
    }
    if (status != 200) {
      throw AiFailure('Gemini returned HTTP $status.');
    }
    try {
      if (jsonDecode(response.body) case {
        'candidates': [{'content': {'parts': final List<Object?> parts}}, ...],
      }) {
        final text = parts
            .map(
              (p) => p is Map && p['text'] is String ? p['text'] as String : '',
            )
            .join();
        if (text.isNotEmpty) return AiReply(text);
      }
    } on FormatException {
      // Falls through to the error below.
    }
    throw const AiFailure('Gemini returned no text.');
  }
}
