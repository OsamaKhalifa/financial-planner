/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/assumptions/assumptions_providers.dart';
import '../investments_providers.dart';
import 'labels.dart';

/// The "no zakat due for {year}" switch with its nisab hint and zakatable
/// total (UX 2.10 step 7). The switch is never set automatically (AC-18).
class NoZakatBlock extends ConsumerWidget {
  const NoZakatBlock({super.key, required this.year});

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final noZakat = ref.watch(noZakatYearsProvider).value ?? const <int>{};
    final calc = ref.watch(calculatorProvider).value;
    final hint = calc?.nisabHint();
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          key: ValueKey('no-zakat-$year'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.noZakatSwitch('$year')),
          value: noZakat.contains(year),
          onChanged: (v) => ref
              .read(assumptionsRepositoryProvider)
              .setNoZakatYear(year, noZakat: v),
        ),
        Text(l10n.noZakatHelp, style: textTheme.bodySmall),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(
            hint.goldNisab == null
                ? l10n.nisabNoGold
                : l10n.nisabGold(context.money(hint.goldNisab!.amount, hint.goldNisab!.unit)),
          ),
          Text(
            hint.silverNisab == null
                ? l10n.nisabNoSilver
                : l10n.nisabSilver(context.money(hint.silverNisab!.amount, hint.silverNisab!.unit)),
          ),
          Text(
            l10n.zakatableTotal(
              context.money(hint.zakatableTotal.amount, hint.zakatableTotal.unit),
            ),
          ),
        ],
      ],
    );
  }
}
