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
}
