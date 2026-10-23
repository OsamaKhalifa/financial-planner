/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:financial_planner/features/export/data/google_sheets_client.dart';
import 'package:financial_planner/features/export/export_tables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const tabs = [
  SheetTab(
    'Items',
    ['Name', 'Value'],
    [
      ['Fund A', null],
    ],
  ),
  SheetTab('Empty', ['Year'], []),
];

void main() {
  test(
    'creates the tabs with a bold frozen header, then writes the rows',
    () async {
      final requests = <http.Request>[];
      final client = GoogleSheetsClient(
        accessToken: 'token-1',
        httpClient: MockClient((r) async {
          requests.add(r);
          return requests.length == 1
              ? http.Response(
                  jsonEncode({
                    'spreadsheetId': 'sheet-1',
                    'spreadsheetUrl':
                        'https://docs.google.com/spreadsheets/d/sheet-1',
                  }),
                  200,
                )
              : http.Response('{}', 200);
        }),
      );

      final url = await client.create('My export', tabs);

      expect(url, Uri.parse('https://docs.google.com/spreadsheets/d/sheet-1'));
      expect(requests.map((r) => r.url.path), [
        '/v4/spreadsheets',
        '/v4/spreadsheets/sheet-1/values:batchUpdate',
      ]);
      for (final r in requests) {
        expect(r.headers['authorization'], 'Bearer token-1');
      }

      final create = jsonDecode(requests[0].body) as Map<String, dynamic>;
      expect(create['properties'], {'title': 'My export'});
      final sheet = (create['sheets'] as List).first as Map<String, dynamic>;
      expect(sheet['properties'], {
        'title': 'Items',
        'gridProperties': {'frozenRowCount': 1},
      });
      final header = sheet['data'][0]['rowData'][0]['values'] as List;
      expect(header.map((c) => c['userEnteredValue']['stringValue']), [
        'Name',
        'Value',
      ]);
      expect(header.first['userEnteredFormat']['textFormat'], {'bold': true});

      final write = jsonDecode(requests[1].body) as Map<String, dynamic>;
      expect(write['valueInputOption'], 'USER_ENTERED');
      // The empty tab sends no rows.
      expect(write['data'], [
        {
          'range': "'Items'!A2",
          'values': [
            ["'Fund A", ''],
          ],
        },
      ]);
    },
  );

  test('401 is an expired sign-in; other errors are a failure', () async {
    GoogleSheetsClient answering(int status) => GoogleSheetsClient(
      accessToken: 't',
      httpClient: MockClient((_) async => http.Response('{}', status)),
    );

    await expectLater(
      answering(401).create('x', tabs),
      throwsA(isA<ExportAuthFailed>()),
    );
    await expectLater(
      answering(403).create('x', tabs),
      throwsA(isA<ExportFailed>()),
    );
    await expectLater(
      answering(500).create('x', tabs),
      throwsA(
        isA<ExportFailed>().having(
          (e) => e.message,
          'message',
          contains('500'),
        ),
      ),
    );
  });

  test('a network error is a failure', () async {
    final client = GoogleSheetsClient(
      accessToken: 't',
      httpClient: MockClient(
        (_) async => throw http.ClientException('offline'),
      ),
    );
    await expectLater(client.create('x', tabs), throwsA(isA<ExportFailed>()));
  });

  test('cell text is what a user would type', () {
    expect(cellText(null), '');
    expect(cellText(Decimal.parse('-1234.5678')), '-1234.5678');
    expect(cellText(2026), '2026');
    expect(cellText(Percent(Decimal.parse('0.12345'))), '12.35%');
    expect(cellText(Percent(Decimal.parse('-0.05'))), '-5.00%');
    expect(cellText(DateTime.utc(2026, 4, 3)), '2026-04-03');
    expect(cellText(DateTime(2026, 4, 3, 9, 5)), '2026-04-03 09:05');
    // Text always stays text: no formulas, no dates out of notes.
    expect(cellText('=HYPERLINK("x")'), "'=HYPERLINK(\"x\")");
    expect(cellText('1/2'), "'1/2");
    expect(cellText('Fund A'), "'Fund A");
  });
}
