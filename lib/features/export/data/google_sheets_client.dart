/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;

import '../export_tables.dart';

/// Google refused the token: it expired or the user removed the app's access.
class ExportAuthFailed implements Exception {
  const ExportAuthFailed();
}

class ExportFailed implements Exception {
  const ExportFailed(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Creates one spreadsheet in the user's Drive with their own access token.
class GoogleSheetsClient {
  GoogleSheetsClient({
    required http.Client httpClient,
    required this._accessToken,
    this._timeout = const Duration(seconds: 30),
  }) : _http = httpClient;

  /// Only the files this app creates; never the user's other Drive files.
  static const scope = 'https://www.googleapis.com/auth/drive.file';

  final http.Client _http;
  final String _accessToken;
  final Duration _timeout;

  /// Returns the link to the new spreadsheet.
  Future<Uri> create(String title, List<SheetTab> tabs) async {
    final created = _json(
      await _post('/v4/spreadsheets', {
        'properties': {'title': title},
        'sheets': [for (final t in tabs) _sheet(t)],
      }),
    );
    final id = created['spreadsheetId'] as String;
    final data = [
      for (final t in tabs)
        if (t.rows.isNotEmpty)
          {
            'range': "'${t.title}'!A2",
            'values': [
              for (final row in t.rows) [for (final c in row) cellText(c)],
            ],
          },
    ];
    if (data.isNotEmpty) {
      _json(
        await _post('/v4/spreadsheets/$id/values:batchUpdate', {
          // Typed as if by hand, so "12.5" is a number and "2026-10-23" a date.
          'valueInputOption': 'USER_ENTERED',
          'data': data,
        }),
      );
    }
    return Uri.parse(created['spreadsheetUrl'] as String);
  }

  Map<String, Object?> _sheet(SheetTab t) => {
    'properties': {
      'title': t.title,
      'gridProperties': {'frozenRowCount': 1},
    },
    'data': [
      {
        'startRow': 0,
        'startColumn': 0,
        'rowData': [
          {
            'values': [
              for (final h in t.header)
                {
                  'userEnteredValue': {'stringValue': h},
                  'userEnteredFormat': {
                    'textFormat': {'bold': true},
                  },
                },
            ],
          },
        ],
      },
    ],
  };

  Future<http.Response> _post(String path, Map<String, Object?> body) async {
    try {
      return await _http
          .post(
            Uri.https('sheets.googleapis.com', path),
            headers: {
              'content-type': 'application/json',
              'authorization': 'Bearer $_accessToken',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const ExportFailed('Google Sheets did not answer in time.');
    } on http.ClientException catch (e) {
      throw ExportFailed('Could not reach Google Sheets: ${e.message}');
    }
  }

  Map<String, Object?> _json(http.Response response) {
    final status = response.statusCode;
    if (status == 401) throw const ExportAuthFailed();
    if (status == 403) {
      throw const ExportFailed(
        'Google refused the export. Check that the Google Sheets API is '
        'enabled for this app.',
      );
    }
    if (status < 200 || status >= 300) {
      throw ExportFailed('Google Sheets failed (HTTP $status).');
    }
    return jsonDecode(response.body) as Map<String, Object?>;
  }
}

/// What a user would type: numbers as exact digits, percents with "%",
/// days as yyyy-MM-dd.
String cellText(Object? cell) => switch (cell) {
  null => '',
  final Decimal d => d.toString(),
  final int n => '$n',
  Percent(:final fraction) =>
    '${(fraction * Decimal.fromInt(100)).toStringAsFixed(2)}%',
  final DateTime t when t.isUtc && t == DateTime.utc(t.year, t.month, t.day) =>
    _day(t),
  final DateTime t => _minute(t.toLocal()),
  // A leading ' keeps text as text: a name "=…" would run as a formula, a
  // note "1/2" turn into a date.
  final String s => "'$s",
  _ => throw ArgumentError.value(cell, 'cell'),
};

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';

String _minute(DateTime t) => '${_day(t)} ${_two(t.hour)}:${_two(t.minute)}';

String _two(int n) => n.toString().padLeft(2, '0');
