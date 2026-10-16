/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';

import 'widgets/labels.dart';

/// Content of the "why" sheet (S9): what a number is, the user's numbers, the
/// assumptions behind it and its source.
class Why {
  const Why({
    required this.title,
    required this.what,
    this.numbers,
    this.assumptions = const [],
    this.source,
  });

  final String title;
  final String what;
  final String? numbers;
  final List<String> assumptions;
  final String? source;
}

Future<void> showWhy(BuildContext context, Why why) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => WhySheet(why),
);

class WhySheet extends StatelessWidget {
  const WhySheet(this.why, {super.key});

  final Why why;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    Widget block(String heading, Widget body) => Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: textTheme.titleSmall),
          const SizedBox(height: 4),
          body,
        ],
      ),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(why.title, style: textTheme.titleLarge),
          block(l10n.whyWhat, Text(why.what)),
          if (why.numbers != null)
            block(l10n.whyNumbers, Text(why.numbers!)),
          if (why.assumptions.isNotEmpty)
            block(
              l10n.whyAssumptions,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final a in why.assumptions) Text('• $a')],
              ),
            ),
          if (why.source != null) block(l10n.whySource, Text(why.source!)),
        ],
      ),
    );
  }
}

/// A number with an info button that opens its why sheet; the whole row is
/// the tap target.
class FigureRow extends StatelessWidget {
  const FigureRow({
    super.key,
    required this.label,
    required this.value,
    this.why,
    this.emphasis = false,
  });

  final String label;
  final String value;
  final Why? why;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final style = emphasis
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return InkWell(
      onTap: why == null ? null : () => showWhy(context, why!),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(child: Text(label, style: style)),
            const SizedBox(width: 8),
            Text(value, style: style),
            if (why != null)
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 4),
                child: Icon(Icons.info_outline, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
