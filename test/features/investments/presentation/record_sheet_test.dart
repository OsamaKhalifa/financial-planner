/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/expected_plan.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/record_sheet.dart';
import 'package:financial_planner/features/investments/presentation/widgets/fields.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/plan_seeds.dart';

HistoryEntry? editing;
RecordPreset? preset;
PlanRow? row;
String itemId = 'a';

class _Opener extends StatelessWidget {
  const _Opener();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () => showRecordSheet(
          context,
          investmentId: itemId,
          editing: editing,
          preset: preset,
          row: row,
        ),
        child: const Text('open'),
      ),
    ),
  );
}

Future<void> seedFund(
  Harness h, {
  List<HistoryEntry> more = const [],
  String? start,
}) async {
  await h.setup();
  await h.addItem(
    item('a', start: start == null ? day(2026, 1, 1) : day(2026, 10, 10)),
    [
      moneyIn('a', start == null ? day(2026, 1, 1) : day(2026, 10, 10), '1000'),
      value('a', day(2026, 9, 1), '1000'),
      ...more,
    ],
  );
}

Future<void> seedGold(Harness h, {List<HistoryEntry> more = const []}) async {
  await h.setup();
  await h.addItem(
    item(
      'a',
      type: AssetType.gold,
      unit: xauG,
      intent: Intent.longTerm,
      rule: ZakatRule.bullion100,
      karat: 21,
    ),
    [
      moneyIn('a', day(2026, 1, 1), '70000'),
      value('a', day(2026, 1, 1), '17.5'),
      ...more,
    ],
  );
}

Future<void> open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> amount(WidgetTester tester, String text) async {
  await tester.enterText(
    find.descendant(
      of: find.byKey(const ValueKey('record-amount')),
      matching: find.byType(TextField),
    ),
    text,
  );
  await tester.pumpAndSettle();
}

Future<void> saveSheet(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('record-save')));
  await tester.pumpAndSettle();
}

Future<List<HistoryEntry>> history(WidgetTester tester, Harness h) async {
  late List<HistoryEntry> out;
  await tester.runAsync(() async => out = (await h.items()).single.history);
  return out;
}

void main() {
  for (final locale in [en, ar]) {
    group('S5 record sheet (${locale.languageCode})', () {
      setUp(() {
        editing = null;
        preset = null;
        row = null;
        itemId = 'a';
      });

      testScreen(
        'A1: gold grams are typed gross; the value stored is the pure grams (21k: 20 g = 17.5 g)',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedGold,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          expect(find.text(l10n.fieldGrams), findsOneWidget);
          await amount(tester, '20');
          expect(
            textPlain(plain(l10n.pureGramsPreview('17.50 g'))),
            findsOneWidget,
          );
          await saveSheet(tester);
          final values = (await history(
            tester,
            h,
          )).whereType<ValueUpdate>().toList();
          expect(
            values.firstWhere((v) => v.date == day(2026, 10, 16)).value,
            Decimal.parse('17.5'),
          );
        },
      );

      testScreen('A1: 18k gold uses its own purity', (tester) async {
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.addItem(
              item(
                'a',
                type: AssetType.gold,
                unit: xauG,
                intent: Intent.longTerm,
                rule: ZakatRule.bullion100,
                karat: 18,
              ),
              [
                moneyIn('a', day(2026, 1, 1), '40000'),
                value('a', day(2026, 1, 1), '9'),
              ],
            );
          },
        );
        await open(tester);
        await amount(tester, '12');
        await saveSheet(tester);
        final values = (await history(
          tester,
          h,
        )).whereType<ValueUpdate>().toList();
        expect(
          values.firstWhere((v) => v.date == day(2026, 10, 16)).value,
          Decimal.parse('9'),
        );
      });

      testScreen(
        'A1: money in with grams after, and editing a metal value, show gross grams',
        (tester) async {
          final entry = value('a', day(2026, 10, 1), '17.5');
          editing = entry;
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: (h) => seedGold(h, more: [entry]),
          );
          await open(tester);
          expect(
            tester
                .widget<TextField>(
                  find.descendant(
                    of: find.byKey(const ValueKey('record-amount')),
                    matching: find.byType(TextField),
                  ),
                )
                .controller!
                .text,
            '20',
          );
          await amount(tester, '24');
          await saveSheet(tester);
          final saved = (await history(
            tester,
            h,
          )).whereType<ValueUpdate>().firstWhere((v) => v.id == entry.id);
          expect(saved.value, Decimal.parse('21'));
        },
      );

      testScreen('a value update is saved on today and the sheet closes', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: seedFund,
        );
        final l10n = l10nOf(tester);
        await open(tester);
        expect(
          find
              .text(l10n.lastValue(plain('1,000.00 EGP'), ''))
              .evaluate()
              .isEmpty,
          isTrue,
        );
        expect(textPlain('1,000.00 EGP'), findsOneWidget);
        await amount(tester, '1200');
        await saveSheet(tester);
        expect(find.byType(RecordSheet), findsNothing);
        final values = (await history(
          tester,
          h,
        )).whereType<ValueUpdate>().toList();
        expect(
          values.map((v) => v.value),
          containsAll([Decimal.parse('1000'), Decimal.parse('1200')]),
        );
        expect(
          values.firstWhere((v) => v.value == Decimal.parse('1200')).date,
          day(2026, 10, 16),
        );
      });

      testScreen(
        'a value ten times the last one gets a non-blocking check line',
        (tester) async {
          await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedFund,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await amount(tester, '10000');
          expect(find.text(l10n.typoCheck('10')), findsOneWidget);
          await amount(tester, '1100');
          expect(find.byKey(const ValueKey('typo-check')), findsNothing);
        },
      );

      testScreen(
        'a zero money-in amount is refused with the same message as the form',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedFund,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabIn));
          await tester.pumpAndSettle();
          await amount(tester, '0');
          await saveSheet(tester);
          expect(find.text(l10n.errZero), findsOneWidget);
          expect((await history(tester, h)).length, 2);
        },
      );

      testScreen('money in with a value after is two entries on the same day', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: seedFund,
        );
        final l10n = l10nOf(tester);
        await open(tester);
        await tester.tap(find.text(l10n.tabIn));
        await tester.pumpAndSettle();
        await amount(tester, '500');
        await tester.enterText(
          find.widgetWithText(TextField, l10n.fieldValueAfter),
          '1600',
        );
        await saveSheet(tester);
        final all = await history(tester, h);
        expect(all.whereType<MoneyIn>().length, 2);
        expect(
          all
              .whereType<ValueUpdate>()
              .where((v) => v.date == day(2026, 10, 16))
              .single
              .value,
          Decimal.parse('1600'),
        );
      });

      testScreen(
        'money out above the value needs the value left; 0 closes the item',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedFund,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabOut));
          await tester.pumpAndSettle();
          await amount(tester, '1500');
          await saveSheet(tester);
          expect(find.text(l10n.valueLeftRequired), findsOneWidget);
          expect((await history(tester, h)).whereType<MoneyOut>(), isEmpty);

          await tester.enterText(find.byKey(const ValueKey('value-left')), '0');
          await tester.pumpAndSettle();
          expect(find.text(l10n.closesInvestment), findsOneWidget);
          await saveSheet(tester);
          final all = await history(tester, h);
          expect(all.whereType<MoneyOut>().single.kind, MoneyOutKind.sale);
          expect(
            all
                .whereType<ValueUpdate>()
                .where((v) => v.date == day(2026, 10, 16))
                .single
                .value,
            Decimal.zero,
          );
        },
      );

      testScreen('income received is a money out of kind income', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: seedFund,
        );
        final l10n = l10nOf(tester);
        await open(tester);
        await tester.tap(find.text(l10n.tabOut));
        await tester.pumpAndSettle();
        await amount(tester, '40');
        await tester.tap(find.text(l10n.kindIncome));
        await tester.pumpAndSettle();
        await saveSheet(tester);
        expect(
          (await history(tester, h)).whereType<MoneyOut>().single.kind,
          MoneyOutKind.income,
        );
      });

      testScreen(
        'AC-68: income above the value does not ask for the value left',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedFund,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabOut));
          await tester.pumpAndSettle();
          await amount(tester, '1500');
          await tester.tap(find.text(l10n.kindIncome));
          await tester.pumpAndSettle();
          await saveSheet(tester);
          expect(find.text(l10n.valueLeftRequired), findsNothing);
          final out = (await history(tester, h)).whereType<MoneyOut>().single;
          expect(out.kind, MoneyOutKind.income);
          expect(out.amount.amount, Decimal.parse('1500'));
          expect((await history(tester, h)).whereType<ValueUpdate>().length, 1);
        },
      );

      testScreen(
        'AC-19: interest received is recorded as kept inside or paid out',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: seedFund,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabInterest));
          await tester.pumpAndSettle();
          expect(find.text(l10n.interestNote), findsOneWidget);
          await amount(tester, '50');
          await tester.tap(find.text(l10n.interestKeptInside));
          await tester.pumpAndSettle();
          await saveSheet(tester);
          final kinds = (await history(
            tester,
            h,
          )).whereType<InterestRecord>().map((e) => e.kind).toList();
          expect(kinds, [InterestKind.keptInside]);
        },
      );

      testScreen(
        'giving interest away: only the cases with interest are offered, never more than is left',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: (h) => seedFund(
              h,
              more: [
                interest('a', day(2026, 6, 30), '500', InterestKind.keptInside),
              ],
            ),
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabInterest));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.interestGivenAway));
          await tester.pumpAndSettle();
          expect(find.text(l10n.givenAwayNote), findsOneWidget);
          expect(find.text(l10n.effectKept), findsOneWidget);
          expect(find.text(l10n.interestPaidOut), findsNothing);
          await amount(tester, '600');
          await saveSheet(tester);
          expect(find.byKey(const ValueKey('record-error')), findsOneWidget);
          expect(
            textPlain(plain(l10n.errGivenTooMuch('500.00 EGP'))),
            findsOneWidget,
          );
          await amount(tester, '300');
          await saveSheet(tester);
          expect(find.byType(RecordSheet), findsNothing);
          final given = (await history(tester, h))
              .whereType<InterestRecord>()
              .where((e) => e.kind == InterestKind.givenAwayFromInside);
          expect(given.single.amount.amount, Decimal.fromInt(300));
        },
      );

      testScreen('with nothing to give away the sheet says so', (tester) async {
        preset = RecordPreset.interestGivenAway;
        await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: seedFund,
        );
        final l10n = l10nOf(tester);
        await open(tester);
        expect(find.text(l10n.nothingToPurify), findsOneWidget);
      });

      testScreen('a date before the start date is refused', (tester) async {
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: (h) => seedFund(h, start: 'late'),
        );
        final l10n = l10nOf(tester);
        await open(tester);
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
        await tester.tap(find.text('1').first);
        await tester.tap(
          find.text(
            MaterialLocalizations.of(tester.element(find.byType(Dialog)))
                .okButtonLabel,
          ),
        );
        await tester.pumpAndSettle();
        await amount(tester, '1200');
        await saveSheet(tester);
        expect(
          textPlain(plain(l10n.errBeforeStart('x').split('x').first)),
          findsOneWidget,
        );
        expect((await history(tester, h)).length, 2);
      });

      testScreen(
        'a value update on a day that has one asks before replacing it',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            seed: (h) =>
                seedFund(h, more: [value('a', day(2026, 10, 16), '1100')]),
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await amount(tester, '1300');
          await saveSheet(tester);
          expect(find.byType(AlertDialog), findsOneWidget);
          await tester.tap(find.text(l10n.replace));
          await tester.pumpAndSettle();
          final today = (await history(
            tester,
            h,
          )).whereType<ValueUpdate>().where((v) => v.date == day(2026, 10, 16));
          expect(today.single.value, Decimal.parse('1300'));
        },
      );

      testScreen('editing an entry keeps its id; delete can be undone', (
        tester,
      ) async {
        final entry = value('a', day(2026, 10, 1), '1050');
        editing = entry;
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          seed: (h) => seedFund(h, more: [entry]),
        );
        final l10n = l10nOf(tester);
        await open(tester);
        await amount(tester, '1075');
        await saveSheet(tester);
        var all = await history(tester, h);
        expect(
          all
              .whereType<ValueUpdate>()
              .firstWhere((v) => v.id == entry.id)
              .value,
          Decimal.parse('1075'),
        );
        expect(all.length, 3);

        await open(tester);
        await tester.tap(find.text(l10n.delete));
        await tester.pumpAndSettle();
        all = await history(tester, h);
        expect(all.any((e) => e.id == entry.id), isFalse);
        await tester.tap(find.text(l10n.undo));
        await tester.pumpAndSettle();
        all = await history(tester, h);
        expect(all.any((e) => e.id == entry.id), isTrue);
      });
      PlanRow aprilRow() => PlanRow(
        kind: PlanKind.payout,
        k: 1,
        from: day(2026, 1, 16),
        date: day(2026, 4, 15),
        expected: Decimal.parse('5000.00'),
        state: RowState.pending,
        noPayoutLine: true,
      );

      testScreen(
        'AC-69: from a pending row the date stays within ± 7 days; the sheet is preset as income at the expected amount',
        (tester) async {
          itemId = 'fp';
          row = aprilRow();
          final h = await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          await open(tester);
          final date = tester.widget<DateField>(
            find.byKey(const ValueKey('record-date')),
          );
          expect(date.value, day(2026, 4, 15));
          expect(date.firstDate, day(2026, 4, 8));
          expect(date.lastDate, day(2026, 4, 22));
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('expected-header')))
                  .data!,
            ),
            contains('5,000.00 EGP'),
          );
          await saveSheet(tester);
          final out = (await history(tester, h)).whereType<MoneyOut>().single;
          expect(
            (out.kind, out.date, out.amount.amount),
            (MoneyOutKind.income, day(2026, 4, 15), Decimal.parse('5000')),
          );
        },
      );

      testScreen('AC-69: a date outside the window is refused', (tester) async {
        itemId = 'fp';
        row = aprilRow();
        final h = await pumpScreen(
          tester,
          const _Opener(),
          locale: locale,
          now: day(2026, 10, 17),
          seed: seedFriend,
        );
        final l10n = l10nOf(tester);
        await open(tester);
        for (final bad in [day(2026, 4, 23), day(2026, 4, 7)]) {
          tester
              .widget<DateField>(find.byKey(const ValueKey('record-date')))
              .onChanged(bad);
          await tester.pumpAndSettle();
          await saveSheet(tester);
          expect(find.byKey(const ValueKey('record-error')), findsOneWidget);
        }
        expect(
          plain(
            tester
                .widget<Text>(find.byKey(const ValueKey('record-error')))
                .data!,
          ),
          startsWith(plain(l10n.errOutsideWindow('§', '§')).split('§').first),
        );
        expect((await history(tester, h)).whereType<MoneyOut>(), isEmpty);
        tester
            .widget<DateField>(find.byKey(const ValueKey('record-date')))
            .onChanged(day(2026, 4, 8));
        await tester.pumpAndSettle();
        await saveSheet(tester);
        expect(
          (await history(tester, h)).whereType<MoneyOut>().single.date,
          day(2026, 4, 8),
        );
      });

      testScreen(
        'AC-54: income typed by hand near a pending row says it also records that payout; interest does not',
        (tester) async {
          itemId = 'fp';
          await pumpScreen(
            tester,
            const _Opener(),
            locale: locale,
            now: day(2026, 7, 20),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          await open(tester);
          await tester.tap(find.text(l10n.tabOut));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.kindIncome));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('also-records')), findsOneWidget);
          await tester.tap(find.text(l10n.kindSale));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('also-records')), findsNothing);
          await tester.tap(find.text(l10n.tabInterest));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('also-records')), findsNothing);
        },
      );
    });
  }
}
