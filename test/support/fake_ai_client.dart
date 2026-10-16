import 'package:financial_planner/core/ai/ai_client.dart';

/// Use in feature tests: `aiClientProvider.overrideWithValue(FakeAiClient())`.
class FakeAiClient implements AiClient {
  FakeAiClient({this.reply = 'fake reply', this.error});

  final String reply;
  final AiException? error;
  final List<AiPrompt> prompts = [];

  @override
  Future<AiReply> complete(AiPrompt prompt) async {
    prompts.add(prompt);
    if (error case final error?) throw error;
    return AiReply(reply);
  }
}
