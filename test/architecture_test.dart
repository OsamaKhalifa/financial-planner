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

  test('package:http only in the rate refresher and the AI clients', () {
    final bad = violations(
      (p) =>
          p != 'lib/core/assumptions/data/rate_refresher.dart' &&
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
}
