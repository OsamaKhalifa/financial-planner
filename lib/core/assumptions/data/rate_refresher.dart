/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../ids.dart';
import '../../money/decimal_math.dart';
import '../../reference/units.dart';
import '../domain/assumptions_repository.dart';
import '../domain/rate.dart';

/// Both URLs are constants with no query and no headers, so the request is the
/// same for every user (AC-26). The user's pairs are applied after download.
final primaryRatesUrl = Uri.parse(
  'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.min.json',
);
final fallbackRatesUrl = Uri.parse(
  'https://latest.currency-api.pages.dev/v1/currencies/usd.min.json',
);

const _timeout = Duration(seconds: 10);
final _gramsPerTroyOunce = Decimal.parse('31.1034768');

typedef UnitPair = (Unit, Unit);

sealed class RefreshResult {
  const RefreshResult();
}

final class RefreshSucceeded extends RefreshResult {
  const RefreshSucceeded({
    required this.asOf,
    required this.inserted,
    required this.notCovered,
  });

  /// The source's own date, not the phone's.
  final DateTime asOf;
  final int inserted;

  /// Pairs the source cannot price (UX S6).
  final List<UnitPair> notCovered;
}

final class RefreshFailed extends RefreshResult {
  const RefreshFailed(this.reason);

  final String reason;
}

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Not a repository: it makes the app's one network call, only when [refresh]
/// is called (AC-25).
class RateRefresher {
  RateRefresher(this._client, this._repository);

  final http.Client _client;
  final AssumptionsRepository _repository;

  Future<RefreshResult> refresh(Set<UnitPair> neededPairs) async {
    final _Snapshot snapshot;
    try {
      snapshot = await _download();
    } on _Unavailable catch (e) {
      return RefreshFailed(e.reason);
    }
    final rates = <Rate>[];
    final notCovered = <UnitPair>[];
    for (final (from, to) in neededPairs) {
      final rate = snapshot.cross(from, to);
      if (rate == null) {
        notCovered.add((from, to));
      } else {
        rates.add(
          Rate(
            id: newId(),
            from: from,
            to: to,
            rate: rate,
            asOf: snapshot.date,
            source: RateSource.currencyApi,
          ),
        );
      }
    }
    final inserted = await _repository.saveFetchedRates(rates);
    return RefreshSucceeded(
      asOf: snapshot.date,
      inserted: inserted,
      notCovered: notCovered,
    );
  }

  Future<_Snapshot> _download() async {
    try {
      return await _get(primaryRatesUrl);
    } on _Unavailable {
      return _get(fallbackRatesUrl);
    }
  }

  Future<_Snapshot> _get(Uri url) async {
    try {
      final response = await _client.get(url).timeout(_timeout);
      if (response.statusCode != 200) {
        throw _Unavailable('$url answered ${response.statusCode}');
      }
      return _Snapshot.parse(response.body);
    } on _Unavailable {
      rethrow;
    } on Exception catch (e) {
      throw _Unavailable('$url: $e');
    }
  }
}

final class _Unavailable implements Exception {
  const _Unavailable(this.reason);

  final String reason;
}

/// One day of quotes: units of each code per 1 USD.
final class _Snapshot {
  _Snapshot(this.date, this._perUsd);

  final DateTime date;
  final Map<String, Decimal> _perUsd;

  static _Snapshot parse(String body) {
    final Object? json;
    try {
      json = jsonDecode(body);
    } on FormatException {
      throw const _Unavailable('the answer is not JSON');
    }
    if (json is! Map || json['date'] is! String || json['usd'] is! Map) {
      throw const _Unavailable('the answer has no date or usd table');
    }
    final DateTime date;
    try {
      date = DateTime.parse('${json['date']}T00:00:00Z');
    } on FormatException {
      throw const _Unavailable('the answer has an unreadable date');
    }
    final perUsd = <String, Decimal>{};
    for (final e in (json['usd'] as Map).entries) {
      final value = e.value;
      if (value is num && value > 0) {
        perUsd['${e.key}'] = Decimal.parse(value.toString());
      }
    }
    return _Snapshot(date, perUsd);
  }

  /// Units of [u] per 1 USD; metals are grams of pure metal per USD
  /// (the source quotes troy ounces per USD).
  Decimal? _unitsPerUsd(Unit u) {
    if (u.isMetal) {
      final ounces = _perUsd[u == xauG ? 'xau' : 'xag'];
      return ounces == null ? null : ounces * _gramsPerTroyOunce;
    }
    return _perUsd[u.code.toLowerCase()];
  }

  /// A→B, crossed once through this single snapshot (ADR-0003); it is stored
  /// as a plain direct rate, lookups never chain.
  Decimal? cross(Unit a, Unit b) {
    final ua = _unitsPerUsd(a);
    final ub = _unitsPerUsd(b);
    return ua == null || ub == null ? null : divide(ub, ua);
  }
}
