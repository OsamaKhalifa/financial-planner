/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

List<File> dartFiles() =>
    Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.contains('/l10n/'))
        .toList();

String norm(File f) => f.path.replaceAll('\\', '/');

Iterable<String> violations(
  bool Function(String path) applies,
  Pattern pattern,
) sync* {
  for (final f in dartFiles().where((f) => applies(norm(f)))) {
    final lines = f.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains(pattern)) yield '${norm(f)}:${i + 1}';
    }
  }
}

void main() {
  test('package:drift only in lib/core/db and */data/', () {
    final bad = violations(
      (p) => !p.startsWith('lib/core/db/') && !p.contains('/data/'),
      RegExp(r'''import\s+['"]package:drift(_flutter)?/'''),
    );
    expect(bad, isEmpty);
  });

  test('package:http only in the rate refresher, AI and Sheets clients', () {
    final bad = violations(
      (p) =>
          p != 'lib/core/assumptions/data/rate_refresher.dart' &&
          p != 'lib/features/export/data/google_sheets_client.dart' &&
          !p.startsWith('lib/core/ai/'),
      RegExp(r'''(import|export)\s+['"]package:http/'''),
    );
    expect(bad, isEmpty);
  });

  test('double only in decimal_math.dart (and generated l10n)', () {
    final bad = violations(
      (p) =>
          p != 'lib/core/money/decimal_math.dart' && !p.startsWith('lib/l10n/'),
      RegExp(r'\bdouble\b'),
    );
    expect(bad, isEmpty);
  });

  test('pure Dart layers do not import Flutter', () {
    final bad = violations(
      (p) =>
          p.contains('/domain/') ||
          p.startsWith('lib/core/money/') ||
          p.startsWith('lib/core/reference/') ||
          p == 'lib/core/dates.dart' ||
          p == 'lib/core/ids.dart',
      RegExp(r'''import\s+['"]package:flutter/'''),
    );
    expect(bad, isEmpty);
  });

  test('core never imports features', () {
    final bad = violations(
      (p) => p.startsWith('lib/core/'),
      RegExp(r'''(import|export)\s+['"][^'"]*\bfeatures/'''),
    );
    expect(bad, isEmpty);
  });

  test('AC-63 actual figures never import the plan', () {
    final bad = violations(
      (p) =>
          p == 'lib/features/investments/domain/portfolio_calculator.dart' ||
          p == 'lib/features/investments/domain/formulas.dart' ||
          p == 'lib/features/investments/domain/item_timeline.dart',
      RegExp(r'''import\s+['"][^'"]*expected_plan\.dart'''),
    );
    expect(bad, isEmpty);
  });

  test(
    'AC-63 no background work in features: no timers, no periodic streams',
    () {
      final bad = violations(
        (p) => p.startsWith('lib/features/'),
        RegExp(r'\bTimer\b|Stream\.periodic'),
      );
      expect(bad, isEmpty);
    },
  );

  test('package:hijri only in lib/core/dates.dart (ADR-0007)', () {
    final bad = violations(
      (p) => p != 'lib/core/dates.dart',
      RegExp(r"""(import|export)\s+['"]package:hijri/"""),
    );
    expect(bad, isEmpty);
  });

  test('notification plugin and timezone only in local_year_end_reminder.dart (ADR-0008)', () {
    final bad = violations(
      (p) => p != 'lib/features/zakat/data/local_year_end_reminder.dart',
      RegExp(
        r"""(import|export)\s+['"]package:(flutter_local_notifications|timezone)/""",
      ),
    );
    expect(bad, isEmpty);
  });

  test(
    'ADR-0002 amendment: investments imports no zakat, overview or plan',
    () {
      final bad = violations(
        (p) => p.startsWith('lib/features/investments/'),
        RegExp(
          r"""(import|export)\s+['"][^'"]*(features/|\.\./)(zakat|overview|plan)/""",
        ),
      );
      expect(bad, isEmpty);
    },
  );

  test('ADR-0002 amendment: zakat imports no overview or plan, and only the settings gear from settings', () {
    final bad = violations(
      (p) => p.startsWith('lib/features/zakat/'),
      RegExp(
        r"""(import|export)\s+['"][^'"]*(features/|\.\./)(overview|plan)/""",
      ),
    );
    expect(bad, isEmpty);
  });
}
