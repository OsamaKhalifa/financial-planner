import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'cloud_ai_client.dart';

/// Cloud AI is opt-in: off until the user turns it on. Kept in memory;
/// persisting the choice belongs to a settings feature.
final aiCloudEnabledProvider =
    NotifierProvider<AiCloudEnabled, bool>(AiCloudEnabled.new);

class AiCloudEnabled extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool enabled) => state = enabled;
}

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
  if (!ref.watch(aiCloudEnabledProvider)) {
    return const _UnavailableAiClient('Cloud AI is turned off.');
  }
  final config = ref.watch(aiProxyConfigProvider);
  if (config == null) {
    return const _UnavailableAiClient('AI proxy is not configured.');
  }
  final httpClient = http.Client();
  ref.onDispose(httpClient.close);
  return CloudAiClient(
    httpClient: httpClient,
    proxyUrl: config.url,
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
