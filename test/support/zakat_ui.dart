/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'app_harness.dart';

/// The app's medium date as the screen writes it, without isolates.
String shownDate(WidgetTester tester, DateTime d) => plain(
  MaterialLocalizations.of(tester.element(find.byType(Scaffold).first))
      .formatMediumDate(d),
);

/// The text of one Text widget, without isolates.
String textOf(WidgetTester tester, Finder f) {
  final w = tester.widget(f);
  final text = w is Text
      ? w
      : tester.widget<Text>(
          find.descendant(of: f, matching: find.byType(Text)).first,
        );
  return plain(text.data!);
}

Future<void> pickCycleDate(
  WidgetTester tester,
  Locale locale,
  ZakatYear calendar,
  int month,
  int dayOfMonth,
) async {
  final l10n = l10nOf(tester);
  final label = calendar == ZakatYear.lunar
      ? '$month · ${l10n.hijriMonth('$month')}'
      : DateFormat.MMMM(locale.languageCode).format(DateTime(2000, month));
  await tester.tap(find.byKey(ValueKey('cycle-month-${calendar.name}')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey('cycle-day-${calendar.name}')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('$dayOfMonth').last);
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final f = find.byKey(ValueKey(key));
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

/// Scrolls the page behind any sheet until [target] shows.
Future<void> scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  final f = find.text(text).first;
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> closeSheet(WidgetTester tester) async {
  await tester.tapAt(const Offset(5, 5));
  await tester.pumpAndSettle();
}

Future<void> enter(WidgetTester tester, Finder field, String text) async {
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pumpAndSettle();
}

Finder inKey(String key) => find.descendant(
  of: find.byKey(ValueKey(key)),
  matching: find.byType(TextField),
);

/// What the year screen shows as plain text, for scans.
String allText(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => plain(t.data ?? t.textSpan?.toPlainText() ?? ''))
    .join('\n');

/// Taps the name of an investment line, the part that opens the investment.
Future<void> openLine(WidgetTester tester, String name) async {
  final title = find.descendant(
    of: find.byKey(ValueKey('line-$name')),
    matching: find.text(name),
  );
  await tester.ensureVisible(title);
  await tester.pumpAndSettle();
  await tester.tap(title);
  await tester.pumpAndSettle();
}

String fieldText(WidgetTester tester, String key) {
  final w = tester.widget(find.byKey(ValueKey(key)));
  return (w is TextField ? w : tester.widget<TextField>(inKey(key)))
      .controller!
      .text;
}

/// Opens the date field [key] and picks [dayOfMonth] of the month it shows.
Future<void> pickDate(WidgetTester tester, String key, int dayOfMonth) async {
  await tapKey(tester, key);
  final dialog = find.byType(DatePickerDialog);
  final l10n = MaterialLocalizations.of(tester.element(dialog));
  await tester.tap(
    find.descendant(
      of: dialog,
      matching: find.text(l10n.formatDecimal(dayOfMonth)),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(l10n.okButtonLabel));
  await tester.pumpAndSettle();
}

/// The first and last day the open date picker offers.
(DateTime, DateTime) pickerBounds(WidgetTester tester) {
  final d = tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));
  DateTime utc(DateTime v) => DateTime.utc(v.year, v.month, v.day);
  return (utc(d.firstDate), utc(d.lastDate));
}

/// The rows of the log, newest first.
Finder get giftRows => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey<String> &&
      (w.key! as ValueKey<String>).value.startsWith('gift-row-'),
);

/// Opens the unit picker behind [key] and picks [code] by searching for it.
Future<void> pickUnit(WidgetTester tester, String key, String code) async {
  await tapKey(tester, key);
  await tester.enterText(find.byType(TextField).last, code);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey('unit-$code')).last);
  await tester.pumpAndSettle();
}

Future<void> write(WidgetTester tester, Future<void> Function() body) async {
  await tester.runAsync(body);
  await settle(tester);
}

/// One write at a time, the screen settled between them: the in-memory
/// database does not like two writes while the screen's streams refresh.
Future<void> writes(
  WidgetTester tester,
  List<Future<void> Function()> steps,
) async {
  for (final step in steps) {
    await write(tester, step);
  }
}

/// All text under [root], without isolates, one string.
String allTextIn(WidgetTester tester, Finder root) => tester
    .widgetList<Text>(find.descendant(of: root, matching: find.byType(Text)))
    .map((t) => plain(t.data ?? t.textSpan?.toPlainText() ?? ''))
    .join(' | ');
