/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every text that shows an expected figure (P-3, AC-67).
const _expectedKeys = [
  'expectedTitle',
  'expectedSubtitle',
  'blockPayouts',
  'blockValueChecks',
  'fieldPayoutSchedule',
  'fieldValueCheckSchedule',
  'fieldExpectedProfit',
  'fieldExpectedGrowth',
  'estimateHelp',
  'payoutPreview',
  'growthPreview',
  'errPickPayoutSchedule',
  'errPickValueSchedule',
  'errProfitPositive',
  'errGrowthTooLow',
  'needsRateForEstimates',
  'editRowsRebuilt',
  'toConfirmTitle',
  'confirmAll',
  'confirmAllLine',
  'confirmValueLine',
  'rowPayout',
  'rowPayoutPurify',
  'rowValue',
  'rowValueExpected',
  'receivedThisAmount',
  'valueAsExpected',
  'addAmount',
  'addValue',
  'skipRow',
  'noPayoutLine',
  'noPayoutPartnership',
  'recordedSnack',
  'recordedAllSnack',
  'skippedSnack',
  'rowsNeedAmount',
  'showMoreRows',
  'kindSkipped',
  'valueBelowEstimate',
  'planCardTitle',
  'expectedSoFar',
  'receivedLabel',
  'differenceLabel',
  'receivedSinceStart',
  'caseCReceived',
  'valueVsEstimate',
  'estimatesFooter',
  'chartLegend',
  'chartPayoutsSummary',
  'chartValueSummary',
  'stateReceived',
  'stateRecorded',
  'stateToConfirm',
  'stateSkipped',
  'toConfirmPill',
  'rowPlanProfit',
  'rowPlanGrowth',
  'rowPlanBoth',
  'rowPlanGrowthOnly',
  'expectedHeader',
  'alsoRecordsPayout',
  'alsoRecordsValue',
  'errOutsideWindow',
  'periodPayouts',
];

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('AC-67 expected figures never use the banned words', () {
    final en = _arb('en');
    final banned = RegExp(
      r'\b(interest|guaranteed|promised|fixed return|yield|late|missed|default)\b',
      caseSensitive: false,
    );
    for (final k in _expectedKeys) {
      expect(en[k], isA<String>(), reason: k);
      expect(banned.hasMatch(en[k] as String), isFalse, reason: '$k: ${en[k]}');
    }
  });

  test('AC-67 "interest" appears only in the two allowed conventional-deposit texts', () {
    final en = _arb('en');
    expect(en['rowInterest'], 'Expected interest (to purify)');
    expect(
      en['noticeConventional'],
      'This is interest. Record it as money out "interest (to purify)", not as income.',
    );
  });

  test('Arabic: expected figures say ربح for profit, never فائدة', () {
    final ar = _arb('ar');
    for (final k in [
      ..._expectedKeys,
      'q1ProfitBasis',
      'q1Share',
      'noticeProfitPayoutsOnly',
    ]) {
      expect((ar[k] as String).contains('فائدة'), isFalse, reason: k);
    }
    expect((ar['fieldExpectedProfit'] as String).contains('ربح'), isTrue);
  });

  group('AC-41 zakat texts', () {
    // A My Investments form text (S3), not a Zakat-tab text: it says "by
    // default" about the sukuk share.
    const notOnZakatTab = {'zakatReasonSukuk'};

    Map<String, String> zakatTexts(String lang) => {
      for (final e in _arb(lang).entries)
        if (e.value is String &&
            !notOnZakatTab.contains(e.key) &&
            (e.key.startsWith('zakat') ||
                e.key.startsWith('reminder') ||
                e.key.startsWith('src_C')))
          e.key: e.value as String,
    };

    // As a word: المستقبل (the future) contains the letters of تقبّل.
    final tabbal = RegExp('(^|[^\u0621-\u064A])[يتنأ]?تقبل');

    String bare(String s) => s.replaceAll(RegExp('[\u064B-\u0652]'), '');

    test('en: no claim of payment, acceptance or fulfilment, and no tone-breaking word', () {
      final claims = RegExp(
        r'zakat paid|accepted|fulfilled|your duty is done',
        caseSensitive: false,
      );
      final tone = RegExp(
        r'\b(late|missed|overdue|default)\b',
        caseSensitive: false,
      );
      final texts = zakatTexts('en');
      expect(texts.length, greaterThan(150));
      for (final e in texts.entries) {
        expect(
          claims.hasMatch(e.value),
          isFalse,
          reason: '${e.key}: ${e.value}',
        );
        expect(tone.hasMatch(e.value), isFalse, reason: '${e.key}: ${e.value}');
      }
    });

    test(
      'ar: no برئت الذمة, no تقبّل, and the settled chip is never مكتملة',
      () {
        final texts = zakatTexts('ar');
        expect(texts.length, greaterThan(150));
        for (final e in texts.entries) {
          final t = bare(e.value);
          expect(t.contains('برئت الذمة'), isFalse, reason: e.key);
          expect(tabbal.hasMatch(t), isFalse, reason: e.key);
          expect(t.contains('مكتملة'), isFalse, reason: e.key);
        }
      },
    );

    test('the settled chip reads مسجَّلة بالكامل, and a frozen year below nisab never reads settled alone', () {
      final ar = _arb('ar')['zakatState'] as String;
      final en = _arb('en')['zakatState'] as String;
      expect(ar, contains('settled{مسجَّلة بالكامل}'));
      expect(ar, contains('belowNisab{دون النصاب: لا زكاة واجبة}'));
      expect(en, contains('belowNisab{Below nisab: no zakat due}'));
    });

    test(
      'C11 line is one key with the Quran 9:60 reference, in both languages',
      () {
        expect(
          _arb('en')['zakatGiftLogNote'],
          'The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat.',
        );
        expect(_arb('ar')['zakatGiftLogNote'], contains('التوبة 60'));
      },
    );
  });
}
