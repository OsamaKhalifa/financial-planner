import 'package:financial_planner/core/ai/ai_vendors.dart';
import 'package:financial_planner/features/export/export_providers.dart';
import 'package:financial_planner/features/export/export_tables.dart';
import 'package:financial_planner/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_vendor.dart';
import '../../support/fake_google_account.dart';

class FakeExportController extends ExportController {
  FakeExportController(this.result);

  final ExportState result;
  final runs = <ExportMode>[];

  @override
  Future<void> run(ExportMode mode) async {
    runs.add(mode);
    state = result;
  }
}

void main() {
  const storage = FlutterSecureStorage();

  Future<void> pumpSettings(
    WidgetTester tester, {
    List<AiVendor> vendors = defaultAiVendors,
    FakeGoogleAccount? account,
    ExportController? export,
  }) async {
    // Tall enough that every row is built and tappable.
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiVendorsProvider.overrideWithValue(vendors),
          googleAccountProvider.overrideWith(
            () => account ?? FakeGoogleAccount(),
          ),
          if (export != null)
            exportControllerProvider.overrideWith(() => export),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('off hides the providers; on shows them and saves', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(find.text('Cloud AI is off.'), findsOneWidget);
    expect(find.text('AI provider'), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Google Gemini'), findsOneWidget);
    expect(
      tester
          .widget<RadioGroup<String>>(find.byType(RadioGroup<String>))
          .groupValue,
      isNull,
    );
    expect(find.text('Pick an AI provider to use it.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(await storage.read(key: 'ai.cloudEnabled'), 'true');
  });

  testWidgets('pick a vendor, save and remove its key', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'ai.cloudEnabled': 'true'});
    await pumpSettings(tester);

    await tester.tap(find.text('Google Gemini'));
    await tester.pumpAndSettle();
    expect(find.text('Add your Google Gemini key to use it.'), findsOneWidget);
    expect(find.text('Google Gemini API key'), findsOneWidget);

    final field = find.byType(TextField);
    expect(tester.widget<TextField>(field).obscureText, isTrue);
    await tester.enterText(field, 'secret-key');
    await tester.tap(find.text('Save key'));
    await tester.pumpAndSettle();

    expect(find.text('Using your own Google Gemini key.'), findsOneWidget);
    expect(await storage.read(key: 'ai.vendor'), 'gemini');
    expect(await storage.read(key: 'ai.apiKey.gemini'), 'secret-key');
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);

    await tester.tap(find.text('Remove key'));
    await tester.pumpAndSettle();

    expect(find.text('Add your Google Gemini key to use it.'), findsOneWidget);
    expect(await storage.read(key: 'ai.apiKey.gemini'), isNull);
  });

  testWidgets('a newly added vendor shows up with its own key field', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({'ai.cloudEnabled': 'true'});
    await pumpSettings(tester, vendors: [...defaultAiVendors, fakeVendor]);

    await tester.tap(find.text('Fake AI'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'fake-key');
    await tester.tap(find.text('Save key'));
    await tester.pumpAndSettle();

    expect(find.text('Using your own Fake AI key.'), findsOneWidget);
    expect(await storage.read(key: 'ai.apiKey.fakeai'), 'fake-key');
  });

  testWidgets('Google Sheets: link, then both exports appear', (tester) async {
    final export = FakeExportController(
      ExportDone(Uri.parse('https://docs.google.com/spreadsheets/d/s1')),
    );
    await pumpSettings(tester, export: export);
    expect(
      find.textContaining('Nothing leaves this phone until you tap Export'),
      findsOneWidget,
    );
    expect(find.text('Export everything'), findsNothing);

    await tester.tap(find.text('Link Google account'));
    await tester.pumpAndSettle();

    expect(find.text('owner@example.com'), findsOneWidget);
    expect(find.text('Link Google account'), findsNothing);

    await tester.tap(find.text('Export snapshot'));
    await tester.pumpAndSettle();
    expect(export.runs, [ExportMode.snapshot]);
    expect(find.text('Export done.'), findsOneWidget);
    expect(find.text('Open in Sheets'), findsOneWidget);

    await tester.tap(find.text('Export everything'));
    await tester.pumpAndSettle();
    expect(export.runs, [ExportMode.snapshot, ExportMode.full]);

    await tester.tap(find.text('Unlink'));
    await tester.pumpAndSettle();
    expect(find.text('Link Google account'), findsOneWidget);
  });

  testWidgets('Google Sheets: a failed link says why', (tester) async {
    await pumpSettings(
      tester,
      account: FakeGoogleAccount(
        linkError: 'Google sign-in is not set up in this build.',
      ),
    );
    await tester.tap(find.text('Link Google account'));
    await tester.pumpAndSettle();
    expect(
      find.text('Google sign-in is not set up in this build.'),
      findsOneWidget,
    );
    expect(find.text('Export everything'), findsNothing);
  });

  testWidgets('Google Sheets: a failed export shows its message', (
    tester,
  ) async {
    await pumpSettings(
      tester,
      account: FakeGoogleAccount(email: 'owner@example.com'),
      export: FakeExportController(
        const ExportError('Could not reach Google Sheets: offline'),
      ),
    );
    await tester.tap(find.text('Export everything'));
    await tester.pumpAndSettle();
    expect(find.text('Could not reach Google Sheets: offline'), findsOneWidget);
    expect(find.text('Open in Sheets'), findsNothing);
  });
}
