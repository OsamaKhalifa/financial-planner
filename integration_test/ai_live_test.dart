import 'package:financial_planner/core/ai/ai_client.dart';
import 'package:financial_planner/core/ai/ai_providers.dart';
import 'package:financial_planner/core/ai/ai_settings.dart';
import 'package:financial_planner/core/ai/cloud_ai_client.dart';
import 'package:financial_planner/core/ai/gemini_ai_client.dart';
import 'package:financial_planner/features/settings/settings_screen.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

/// Live test against real Gemini, real device storage and the local Worker.
/// Run with `tool/ai_live_test.sh`; skipped when no key is defined.
const _geminiKey = String.fromEnvironment('GEMINI_API_KEY');
const _proxyUrl = String.fromEnvironment('AI_PROXY_URL');
const _appToken = String.fromEnvironment('AI_APP_TOKEN');

final _noKey = _geminiKey.isEmpty || _geminiKey == 'PASTE_YOUR_KEY_HERE';
final _noProxy = _noKey || _proxyUrl.isEmpty || _appToken.isEmpty;

const _pong = AiPrompt(
  instruction: 'You are a connectivity check.',
  input: 'Reply with exactly the word: pong',
  maxOutputTokens: 256,
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();

  setUp(storage.deleteAll);
  tearDown(storage.deleteAll);

  testWidgets('own key: Settings UI, device storage, real Gemini', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), _geminiKey);
    await tester.tap(find.text('Save key'));
    await tester.pumpAndSettle();
    expect(find.text('Using your own Gemini key.'), findsOneWidget);

    final fresh = ProviderContainer();
    addTearDown(fresh.dispose);
    final saved = await fresh.read(aiSettingsProvider.future);
    expect(saved.cloudEnabled, isTrue);
    expect(saved.ownGeminiKey, _geminiKey);

    final client = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    ).read(aiClientProvider);
    expect(client, isA<GeminiAiClient>());
    final reply = await client.complete(_pong);
    expect(reply.text.toLowerCase(), contains('pong'));
  }, skip: _noKey);

  testWidgets('a rejected key is AiUnavailable', (tester) async {
    final client = GeminiAiClient(
      httpClient: http.Client(),
      apiKey: 'AIzaSyInvalidKeyForLiveTest0000000000000',
    );

    await expectLater(client.complete(_pong), throwsA(isA<AiUnavailable>()));
  }, skip: _noKey);

  testWidgets('shared route: local Worker forwards to real Gemini', (
    tester,
  ) async {
    final client = CloudAiClient(
      httpClient: http.Client(),
      proxyUrl: Uri.parse(_proxyUrl),
      appToken: _appToken,
    );

    final reply = await client.complete(_pong);

    expect(reply.text.toLowerCase(), contains('pong'));
  }, skip: _noProxy);

  testWidgets('shared route: a wrong app token is refused', (tester) async {
    final client = CloudAiClient(
      httpClient: http.Client(),
      proxyUrl: Uri.parse(_proxyUrl),
      appToken: 'wrong-token',
    );

    await expectLater(client.complete(_pong), throwsA(isA<AiFailure>()));
  }, skip: _noProxy);
}
