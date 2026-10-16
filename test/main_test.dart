/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:financial_planner/main.dart';

Future<void> pumpApp(WidgetTester tester, Locale locale) async {
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  await tester.pumpWidget(const ProviderScope(child: App()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('boots in English, left to right', (tester) async {
    await pumpApp(tester, const Locale('en'));
    expect(find.text('Financial Planner'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(HomePage))),
      TextDirection.ltr,
    );
  });

  testWidgets('boots in Arabic, right to left', (tester) async {
    await pumpApp(tester, const Locale('ar'));
    expect(find.text('المخطط المالي'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(HomePage))),
      TextDirection.rtl,
    );
  });
}
