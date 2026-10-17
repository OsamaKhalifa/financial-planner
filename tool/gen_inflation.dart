/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

// Regenerates assets/inflation/cpi_annual.json (ADR-0004). Run by a human
// before a release: dart run tool/gen_inflation.dart
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:http/http.dart' as http;

const _firstYear = 2000;
const _out = 'assets/inflation/cpi_annual.json';

Future<void> main() async {
  final now = DateTime.now().toUtc();
  final codes = v1Countries.map((c) => c.iso3).toList()..sort();
  final url = Uri.parse(
    'https://api.worldbank.org/v2/country/${codes.join(';')}'
    '/indicator/FP.CPI.TOTL.ZG?format=json&date=$_firstYear:${now.year}'
    '&per_page=20000',
  );
  final client = http.Client();
  final http.Response response;
  try {
    response = await client.get(url);
  } finally {
    client.close();
  }
  if (response.statusCode != 200) {
    stderr.writeln('World Bank answered ${response.statusCode}');
    exit(1);
  }
  final body = jsonDecode(response.body) as List<dynamic>;
  final meta = body[0] as Map<String, dynamic>;
  final rows = body[1] as List<dynamic>;

  final series = <String, Map<String, String>>{};
  for (final row in rows.cast<Map<String, dynamic>>()) {
    final value = row['value'];
    if (value == null) continue;
    final percent = Decimal.parse(value.toString()).round(scale: 2);
    series.putIfAbsent(row['countryiso3code'] as String, () => {})[row['date']
        as String] = percent.toStringAsFixed(
      2,
    );
  }
  final missing = codes.where((c) => !series.containsKey(c)).toList();
  if (missing.isNotEmpty) {
    stderr.writeln('No data for: ${missing.join(', ')}');
    exit(1);
  }

  final sorted = {
    for (final c in series.keys.toList()..sort())
      c: {for (final y in series[c]!.keys.toList()..sort()) y: series[c]![y]},
  };
  final asset = {
    'source':
        'World Bank WDI, FP.CPI.TOTL.ZG (Inflation, consumer prices, annual %), '
        'from IMF IFS. CC BY 4.0',
    'sourceLastUpdated': meta['lastupdated'],
    'generatedOn': now.toIso8601String().substring(0, 10),
    'series': sorted,
  };
  File(
    _out,
  ).writeAsStringSync('${const JsonEncoder.withIndent(' ').convert(asset)}\n');
  stdout.writeln(
    'Wrote $_out: ${sorted.length} series, '
    'World Bank last updated ${meta['lastupdated']}.',
  );
}
