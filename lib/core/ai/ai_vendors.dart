import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'gemini_ai_client.dart';

/// An AI provider the user can bring their own key for.
///
/// To add one: write its [AiClient] and add an entry to [defaultAiVendors].
/// Features, Settings and stored data do not change.
class AiVendor {
  const AiVendor({
    required this.id,
    required this.name,
    required this.keyHelp,
    required this.dataNotice,
    required this.createClient,
  });

  /// Stored on the device. Never rename an existing one.
  final String id;
  final String name;

  /// Where the user gets a key.
  final String keyHelp;

  /// Where the user's text goes and how the vendor may use it.
  final String dataNotice;

  final AiClient Function(http.Client httpClient, String apiKey) createClient;
}

/// The vendors offered in Settings, in display order.
const defaultAiVendors = [
  AiVendor(
    id: 'gemini',
    name: 'Google Gemini',
    keyHelp: 'Get a free key at aistudio.google.com.',
    dataNotice:
        'Text goes to Google. On free use, Google may use it to improve '
        'its products.',
    createClient: _gemini,
  ),
];

final aiVendorsProvider = Provider<List<AiVendor>>((ref) => defaultAiVendors);

AiClient _gemini(http.Client httpClient, String apiKey) =>
    GeminiAiClient(httpClient: httpClient, apiKey: apiKey);

AiVendor? vendorById(List<AiVendor> vendors, String? id) {
  for (final vendor in vendors) {
    if (vendor.id == id) return vendor;
  }
  return null;
}
