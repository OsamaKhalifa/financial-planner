import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'ai_settings.dart';
import 'cloud_ai_client.dart';
import 'gemini_ai_client.dart';

class AiProxyConfig {
  const AiProxyConfig({required this.url, required this.appToken});

  final Uri url;
  final String appToken;
}

/// Built from `--dart-define=AI_PROXY_URL=… --dart-define=AI_APP_TOKEN=…`.
/// Null when not set, so builds without AI still run.
final aiProxyConfigProvider = Provider<AiProxyConfig?>((ref) {
  const url = String.fromEnvironment('AI_PROXY_URL');
  const token = String.fromEnvironment('AI_APP_TOKEN');
  if (url.isEmpty || token.isEmpty) return null;
  return AiProxyConfig(url: Uri.parse(url), appToken: token);
});

/// The single place that decides which [AiClient] the app uses.
final aiClientProvider = Provider<AiClient>((ref) {
  final settings = ref.watch(aiSettingsProvider).value;
  if (settings == null) {
    return const _UnavailableAiClient('AI settings are not loaded.');
  }
  if (!settings.cloudEnabled) {
    return const _UnavailableAiClient('Cloud AI is turned off.');
  }
  final ownKey = settings.ownGeminiKey;
  final config = ref.watch(aiProxyConfigProvider);
  if (ownKey == null && config == null) {
    return const _UnavailableAiClient('AI proxy is not configured.');
  }
  final httpClient = http.Client();
  ref.onDispose(httpClient.close);
  if (ownKey != null) {
    return GeminiAiClient(httpClient: httpClient, apiKey: ownKey);
  }
  return CloudAiClient(
    httpClient: httpClient,
    proxyUrl: config!.url,
    appToken: config.appToken,
  );
});

class _UnavailableAiClient implements AiClient {
  const _UnavailableAiClient(this._reason);

  final String _reason;

  @override
  Future<AiReply> complete(AiPrompt prompt) async =>
      throw AiUnavailable(_reason);
}
