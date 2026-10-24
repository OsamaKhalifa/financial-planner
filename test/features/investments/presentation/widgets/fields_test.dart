/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/features/investments/presentation/widgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../support/app_harness.dart';

class _Host extends StatefulWidget {
  const _Host(this.calendar, {this.month, this.day, this.seen});

  final ZakatYear calendar;
  final int? month;
  final int? day;
  final List<(int?, int?)>? seen;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int? month = widget.month;
  late int? day = widget.day;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CycleDateField(
      calendar: widget.calendar,
      month: month,
      day: day,
      onChanged: (m, d) {
        widget.seen?.add((m, d));
        setState(() {
          month = m;
          day = d;
        });
      },
    ),
  );
}

void main() {
  test('cycleDateFits: lunar always allows 30, solar follows the month and allows 29 Feb', () {
    expect(cycleDateFits(ZakatYear.lunar, 9, 30), isTrue);
    expect(cycleDateFits(ZakatYear.solar, 2, 29), isTrue);
    expect(cycleDateFits(ZakatYear.solar, 2, 30), isFalse);
    expect(cycleDateFits(ZakatYear.solar, 4, 31), isFalse);
    expect(cycleDateFits(ZakatYear.solar, 4, 30), isTrue);
    expect(cycleDateFits(ZakatYear.solar, 10, 31), isTrue);
  });

  for (final locale in [en, ar]) {
    group('Z3 cycle date field (${locale.languageCode})', () {
      testScreen('AC-1 starts empty, with no hint and no error', (
        tester,
      ) async {
        await pumpScreen(tester, const _Host(ZakatYear.lunar), locale: locale);
        expect(find.byKey(const ValueKey('cycle-error')), findsNothing);
        expect(find.byKey(const ValueKey('cycle-hint')), findsNothing);
        final menus = tester
            .widgetList<DropdownMenu<int>>(find.byType(DropdownMenu<int>))
            .toList();
        expect(menus.map((m) => m.initialSelection), [null, null]);
      });

      testScreen(
        'AC-1 a lunar month shows its number and Hijri name; day 30 shows the 29-day helper',
        (tester) async {
          final seen = <(int?, int?)>[];
          await pumpScreen(
            tester,
            _Host(ZakatYear.lunar, seen: seen),
            locale: locale,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('cycle-month-lunar')));
          await tester.pumpAndSettle();
          expect(find.text('9 · ${l10n.hijriMonth('9')}'), findsOneWidget);
          await tester.tap(find.text('9 · ${l10n.hijriMonth('9')}').last);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('cycle-day-lunar')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('30').last);
          await tester.pumpAndSettle();
          expect(seen, [(9, null), (9, 30)]);
          expect(find.text(l10n.zakatDay30), findsOneWidget);
          expect(find.byKey(const ValueKey('cycle-error')), findsNothing);
        },
      );

      testScreen(
        'AC-1 solar: 31 April is refused with the month named, 29 February is accepted',
        (tester) async {
          await pumpScreen(
            tester,
            const _Host(ZakatYear.solar, month: 4, day: 31),
            locale: locale,
          );
          final l10n = l10nOf(tester);
          final april = DateFormat.MMMM(locale.languageCode)
              .format(DateTime(2000, 4));
          expect(
            tester.widget<Text>(find.byKey(const ValueKey('cycle-error'))).data,
            l10n.zakatBadDay(april, '30'),
          );
        },
      );

      testScreen('solar days past the month are disabled in the menu', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const _Host(ZakatYear.solar, month: 4),
          locale: locale,
        );
        await tester.tap(find.byKey(const ValueKey('cycle-day-solar')));
        await tester.pumpAndSettle();
        final entry = tester.widget<MenuItemButton>(
          find.widgetWithText(MenuItemButton, '31').last,
        );
        expect(entry.onPressed, isNull);
        final thirty = tester.widget<MenuItemButton>(
          find.widgetWithText(MenuItemButton, '30').last,
        );
        expect(thirty.onPressed, isNotNull);
      });
    });
  }
}
