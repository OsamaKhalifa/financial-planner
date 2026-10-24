/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

// The English texts the zakat story quotes, word for word. The widget tests
// look texts up through the generated l10n class, so a wrong word in the ARB
// file would still pass them; this file pins the words the story promises
// (docs/product/stories/zakat.md, §5-§9 and AC-1…AC-46).

import 'package:financial_planner/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('story texts, word for word (en)', () {
    test('AC-1 the cycle date help names Hijri or Gregorian months (C1)', () {
      expect(
        l10n.zakatCycleHelp('lunar'),
        'Your zakat date is the day your wealth first reached nisab, counted in Hijri months. If you already give zakat on a set date, use that date.',
      );
      expect(
        l10n.zakatCycleHelp('solar'),
        'Your zakat date is the day your wealth first reached nisab, counted in Gregorian months. If you already give zakat on a set date, use that date.',
      );
    });

    test(
      'AC-1 AC-2 AC-6 the past-years, Umm al-Qura and applies-from lines',
      () {
        expect(
          l10n.zakatPastYears('2026'),
          'Zakat from years before 2026 is not counted here. If any of it was not given, it is still owed.',
        );
        expect(
          l10n.zakatUmmAlQuraLine,
          'Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date.',
        );
        expect(
          l10n.zakatChangeAppliesFrom('1448 AH'),
          'The new date applies from the year after 1448 AH.',
        );
      },
    );

    test('AC-9 AC-11 AC-45 the converted, value-date and old-rate lines', () {
      expect(
        l10n.zakatLineConverted('2,000.00 USD', '48.00', 'Oct 20, 2026'),
        '2,000.00 USD · converted at 48.00 on Oct 20, 2026',
      );
      expect(l10n.zakatLineValueDate('Oct 1, 2026'), 'value of Oct 1, 2026');
      expect(
        l10n.zakatOldDateNote('Oct 20, 2026'),
        'Zakat is on the value on your due date. If it changed, add a value or rate for Oct 20, 2026.',
      );
      expect(
        l10n.zakatLineNotRateOf('Oct 20, 2026'),
        'not the rate of Oct 20, 2026',
      );
    });

    test('AC-8 the missing gold rate asks for one to see the nisab', () {
      expect(
        l10n.zakatFixMetalRate('gold', 'Oct 20, 2026'),
        startsWith('Add a gold rate to see the nisab'),
      );
    });

    test('AC-15 AC-17 AC-18 AC-22 the line notices and the debts why-text', () {
      expect(
        l10n.zakatLineDividendsNotice,
        "Zakat on your dividends is counted with your cash. If that cash is not in this year's lines, add it as an extra cash line.",
      );
      expect(
        l10n.zakatExtraDoubtful,
        'A doubtful debt has no zakat until you receive it.',
      );
      expect(l10n.zakatAddsNotDeducted, 'not deducted');
      expect(
        l10n.zakatDebtsWhy,
        'Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here.',
      );
    });

    test('section 7 the result lines (A4, A8, Z-4, C4)', () {
      expect(l10n.zakatNoteA4, 'Nisab is checked on the due date only.');
      expect(
        l10n.zakatNoteA8,
        'Gold, silver and all other wealth are added together by value.',
      );
      expect(
        l10n.zakatNoteZ4,
        'Based on the lines of this year only. Add other cash or money owed to you as an extra line. Add other assets in My Investments.',
      );
      expect(l10n.zakatResultBelow, 'Below nisab: no zakat due for this year.');
      expect(l10n.zakatResultEmpty, 'Nothing to count yet.');
      expect(
        l10n.zakatResultOpenLine('Oct 20, 2027'),
        'Estimate. Your zakat year ends on Oct 20, 2027.',
      );
    });

    test('AC-26 AC-28 AC-29 AC-30 the log texts (C6, C7, C8, C11)', () {
      expect(
        l10n.zakatGiftEarlyHelp,
        'This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date.',
      );
      expect(l10n.zakatGiftOver('500.00'), 'Given 500.00 more than due.');
      expect(
        l10n.zakatGiftOverHelp,
        "Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi'i) count it as sadaqah. The app does not move it.",
      );
      expect(
        l10n.zakatRateViewChanged,
        'Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view.',
      );
    });

    test('AC-31 the close action and the below-nisab state', () {
      expect(l10n.zakatClose, 'Close this year');
      expect(
        l10n.zakatState('belowNisab').toLowerCase(),
        'below nisab: no zakat due',
      );
      expect(
        l10n.zakatFrozenBelow.toLowerCase(),
        startsWith('below nisab: no zakat due'),
      );
    });

    test('AC-35 AC-40 the notification texts (C10)', () {
      expect(
        l10n.reminderBodyToday('2026'),
        'Your zakat year 2026 ends today. Open to see your zakat.',
      );
      expect(
        l10n.reminderBodyToday('1448 AH'),
        'Your zakat year 1448 AH ends today. Open to see your zakat.',
      );
      expect(
        l10n.reminderBodyOn('2027', 'Oct 20, 2027'),
        'Your zakat year 2027 ends on Oct 20, 2027. Open to see your zakat.',
      );
    });

    test('AC-39 the three due texts and the do-not-delay line (C2, C10)', () {
      expect(l10n.zakatDueIs('2025'), 'Your zakat for 2025 is due.');
      expect(
        l10n.zakatDueBelow('2026', 'Oct 20, 2026'),
        'Your zakat year 2026 ended on Oct 20, 2026. Below nisab: no zakat due.',
      );
      expect(
        l10n.zakatDueIncomplete('2024', 'Oct 20, 2024'),
        'Your zakat year 2024 ended on Oct 20, 2024. Complete it to see your zakat.',
      );
      expect(
        l10n.zakatDueDelayLine,
        'Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason.',
      );
    });

    test(
      'AC-35 AC-39 no notification or due text uses the tone-breaking words',
      () {
        final tone = RegExp(
          r'\b(late|missed|overdue|default)\b',
          caseSensitive: false,
        );
        final texts = [
          l10n.reminderBodyToday('2026'),
          l10n.reminderBodyOn('2027', 'Oct 20, 2027'),
          l10n.zakatDueIs('2025'),
          l10n.zakatDueBelow('2026', 'Oct 20, 2026'),
          l10n.zakatDueIncomplete('2024', 'Oct 20, 2024'),
        ];
        for (final t in texts) {
          expect(tone.hasMatch(t), isFalse, reason: t);
          expect(
            t.contains('is due') && t.startsWith('Your zakat year'),
            isFalse,
            reason: t,
          );
        }
      },
    );
  });
}
