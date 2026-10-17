import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'ai_settings.dart';
import 'ai_vendors.dart';

/// The single place that decides which [AiClient] the app uses.
final aiClientProvider = Provider<AiClient>((ref) {
  final settings = ref.watch(aiSettingsProvider).value;
  if (settings == null) {
    return const _UnavailableAiClient('AI settings are not loaded.');
  }
  if (!settings.cloudEnabled) {
    return const _UnavailableAiClient('Cloud AI is turned off.');
  }
  final vendor = vendorById(ref.watch(aiVendorsProvider), settings.vendorId);
  if (vendor == null) {
    return const _UnavailableAiClient('Pick an AI provider in Settings.');
  }
  final apiKey = settings.apiKey;
  if (apiKey == null) {
    return _UnavailableAiClient('Add your ${vendor.name} key in Settings.');
  }
  final httpClient = http.Client();
  ref.onDispose(httpClient.close);
  return vendor.createClient(httpClient, apiKey);
});

class _UnavailableAiClient implements AiClient {
  const _UnavailableAiClient(this._reason);

  final String _reason;

  @override
  Future<AiReply> complete(AiPrompt prompt) async =>
      throw AiUnavailable(_reason);
}
