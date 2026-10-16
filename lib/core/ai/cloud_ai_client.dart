import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_client.dart';

/// Talks to our own proxy (`ai-proxy/`) in a provider-neutral format.
/// The proxy, not the app, knows which AI vendor answers.
class CloudAiClient implements AiClient {
  CloudAiClient({
    required http.Client httpClient,
    required Uri proxyUrl,
    required this._appToken,
    this._timeout = const Duration(seconds: 30),
  }) : _http = httpClient,
       _endpoint = proxyUrl.resolve('/v1/complete');

  final http.Client _http;
  final Uri _endpoint;
  final String _appToken;
  final Duration _timeout;

  @override
  Future<AiReply> complete(AiPrompt prompt) async {
    final http.Response response;
    try {
      response = await _http
          .post(
            _endpoint,
            headers: {
              'content-type': 'application/json',
              'x-app-token': _appToken,
            },
            body: jsonEncode({
              'instruction': prompt.instruction,
              'input': prompt.input,
              'maxOutputTokens': prompt.maxOutputTokens,
            }),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AiFailure('AI request timed out.');
    } on http.ClientException catch (e) {
      throw AiFailure('AI request failed: ${e.message}');
    }

    if (response.statusCode == 429) {
      final seconds = int.tryParse(response.headers['retry-after'] ?? '');
      throw AiQuotaExceeded(
        retryAfter: seconds == null ? null : Duration(seconds: seconds),
      );
    }
    if (response.statusCode != 200) {
      throw AiFailure('AI proxy returned HTTP ${response.statusCode}.');
    }
    try {
      if (jsonDecode(response.body) case {'text': final String text}) {
        return AiReply(text);
      }
    } on FormatException {
      // Falls through to the error below.
    }
    throw const AiFailure('AI proxy returned an unexpected body.');
  }
}
