import 'package:financial_planner/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const storage = FlutterSecureStorage();

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsScreen())),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('starts off and the switch saves the opt-in', (tester) async {
    await pumpSettings(tester);
    expect(find.text('Cloud AI is off.'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text("Using the app's shared AI service."), findsOneWidget);
    expect(await storage.read(key: 'ai.cloudEnabled'), 'true');
  });

  testWidgets('saving and removing an own key', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'ai.cloudEnabled': 'true'});
    await pumpSettings(tester);

    final field = find.byType(TextField);
    expect(tester.widget<TextField>(field).obscureText, isTrue);
    await tester.enterText(field, 'secret-key');
    await tester.tap(find.text('Save key'));
    await tester.pumpAndSettle();

    expect(find.text('Using your own Gemini key.'), findsOneWidget);
    expect(await storage.read(key: 'ai.ownGeminiKey'), 'secret-key');
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);

    await tester.tap(find.text('Remove key'));
    await tester.pumpAndSettle();

    expect(find.text("Using the app's shared AI service."), findsOneWidget);
    expect(await storage.read(key: 'ai.ownGeminiKey'), isNull);
  });
}
