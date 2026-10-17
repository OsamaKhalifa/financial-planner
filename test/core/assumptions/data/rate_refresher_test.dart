/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/assumptions_providers.dart';
import 'package:financial_planner/core/assumptions/data/drift_assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/core/money/decimal_math.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const usd = Unit('USD');
const egp = Unit('EGP');
const sar = Unit('SAR');
Decimal d(String s) => Decimal.parse(s);

late AppDatabase db;
late DriftAssumptionsRepository repo;
late List<http.BaseRequest> requests;
final fixture = File('test/fixtures/currency_api_usd.json').readAsStringSync();

String body(String date, Map<String, num> usdTable) =>
    jsonEncode({'date': date, 'usd': usdTable});

RateRefresher refresher(Future<http.Response> Function(http.Request) handler) =>
    RateRefresher(
      MockClient((r) {
        requests.add(r);
        return handler(r);
      }),
      repo,
    );

Future<List<Rate>> stored() => repo.watchRates().first;

void main() {
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftAssumptionsRepository(db, () => DateTime.utc(2026, 10, 16));
    requests = [];
  });
  tearDown(() => db.close());

  test(
    'AC-25: nothing touches the network until a refresh is asked for',
    () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => DateTime.utc(2026, 10, 16)),
          httpClientProvider.overrideWithValue(
            MockClient((r) {
              requests.add(r);
              return Future.value(http.Response('', 500));
            }),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(rateBookProvider, (_, _) {});
      container.listen(settingsProvider, (_, _) {});
      await container.read(ratesProvider.future);
      await container.read(settingsProvider.future);
      await container.read(rateBookProvider.future);
      container.read(refreshControllerProvider);
      await pumpEventQueue(times: 50);
      expect(requests, isEmpty);

      await container.read(refreshControllerProvider.notifier).refresh({
        (usd, egp),
      });
      expect(requests, isNotEmpty);
      final state = container.read(refreshControllerProvider);
      expect(state, isA<RefreshDone>());
      expect((state as RefreshDone).result, isA<RefreshFailed>());
    },
  );

  test(
    'AC-26: the request is the same for any user, whatever they hold',
    () async {
      final r = refresher((_) async => http.Response(fixture, 200));
      await r.refresh({(usd, egp)});
      await r.refresh({(Unit('GBP'), sar), (xauG, Unit('EUR'))});
      expect(requests.length, 2);
      for (final q in requests) {
        expect(q.method, 'GET');
        expect(q.url, primaryRatesUrl);
        expect(q.url.hasQuery, isFalse);
        expect(q.contentLength, anyOf(isNull, 0));
        expect(
          q.headers.keys.map((k) => k.toLowerCase()),
          isNot(contains('cookie')),
        );
        expect(
          q.headers.keys.map((k) => k.toLowerCase()),
          isNot(contains('authorization')),
        );
      }
      expect(requests[0].headers, requests[1].headers);
    },
  );

  test(
    'AC-27: the stored date is the source date, one row with the source marked',
    () async {
      final r = refresher(
        (_) async =>
            http.Response(body('2026-10-15', {'egp': 48.5, 'usd': 1}), 200),
      );
      final result = await r.refresh({(usd, egp)}) as RefreshSucceeded;
      expect(result.asOf, day(2026, 10, 15));
      expect(result.inserted, 1);
      final rate = (await stored()).single;
      expect((rate.from, rate.to, rate.rate), (usd, egp, d('48.5')));
      expect(rate.asOf, day(2026, 10, 15));
      expect(rate.source, RateSource.currencyApi);
    },
  );

  test('AC-28: a typed rate on the same date stays and wins; the fetched one is kept too', () async {
    await repo.saveTypedRate(
      Rate(from: usd, to: egp, rate: d('49.00'), asOf: day(2026, 10, 15)),
    );
    final r = refresher(
      (_) async =>
          http.Response(body('2026-10-15', {'egp': 48.5, 'usd': 1}), 200),
    );
    await r.refresh({(usd, egp)});
    final all = await stored();
    expect(all.length, 2);
    expect(RateBook(all).quote(usd, egp, day(2026, 10, 15))!.rate, d('49.00'));
  });

  test('AC-29: both URLs failing writes nothing and says why', () async {
    await repo.saveTypedRate(
      Rate(from: usd, to: egp, rate: d('49'), asOf: day(2026, 10, 1)),
    );
    final before = (await stored()).map((r) => r.id).toList();

    for (final handler in <Future<http.Response> Function(http.Request)>[
      (_) => throw const SocketException('offline'),
      (_) async => http.Response('nope', 503),
      (_) async => http.Response('<html>', 200),
      (_) async => http.Response('{"usd":{"egp":1}}', 200),
    ]) {
      requests.clear();
      final result = await refresher(handler).refresh({(usd, egp)});
      expect(result, isA<RefreshFailed>());
      expect((result as RefreshFailed).reason, isNotEmpty);
      expect(requests.map((q) => q.url), [primaryRatesUrl, fallbackRatesUrl]);
      expect((await stored()).map((r) => r.id).toList(), before);
    }
  });

  test('the mirror is used once when the primary fails', () async {
    final r = refresher(
      (q) async => q.url == primaryRatesUrl
          ? http.Response('', 500)
          : http.Response(fixture, 200),
    );
    final result = await r.refresh({(usd, egp)});
    expect(result, isA<RefreshSucceeded>());
    expect(requests.map((q) => q.url), [primaryRatesUrl, fallbackRatesUrl]);
  });

  test('a good primary answer is not followed by a mirror request', () async {
    await refresher((_) async => http.Response(fixture, 200))
        .refresh({(usd, egp)});
    expect(requests.length, 1);
  });

  test(
    'AC-30: gold at 3,110.34768 USD per ounce is stored as 100 USD per gram',
    () async {
      final ounces = divide(Decimal.one, d('3110.34768'));
      final r = refresher(
        (_) async => http.Response(
          body('2026-10-16', {'xau': ounces.toDouble(), 'usd': 1}),
          200,
        ),
      );
      await r.refresh({(xauG, usd)});
      final rate = (await stored()).single;
      expect((rate.from, rate.to), (xauG, usd));
      expect(
        (rate.rate - d('100')).abs() < d('0.00001'),
        isTrue,
        reason: '${rate.rate}',
      );
    },
  );

  test(
    'pairs are crossed once from one snapshot, metals per pure gram',
    () async {
      final table =
          (jsonDecode(fixture) as Map<String, dynamic>)['usd']
              as Map<String, dynamic>;
      Decimal q(String c) => d(table[c].toString());
      final r = refresher((_) async => http.Response(fixture, 200));
      final result = await r.refresh({
        (usd, egp),
        (egp, sar),
        (xauG, egp),
        (xagG, usd),
      }) as RefreshSucceeded;
      expect(result.notCovered, isEmpty);
      final byPair = {for (final x in await stored()) (x.from, x.to): x.rate};
      expect(byPair[(usd, egp)], q('egp'));
      expect(
        (byPair[(egp, sar)]! - divide(q('sar'), q('egp'))).abs() <
            d('0.0000001'),
        isTrue,
      );
      final gram = d('31.1034768');
      final xauEgp = divide(q('egp'), q('xau') * gram);
      expect((byPair[(xauG, egp)]! - xauEgp).abs() < d('0.001'), isTrue);
      expect(
        (byPair[(xagG, usd)]! - divide(d('1'), q('xag') * gram)).abs() <
            d('0.0001'),
        isTrue,
      );
      expect(byPair[(xauG, egp)]! > d('1000'), isTrue);
    },
  );

  test(
    'a pair the source cannot price is reported, the others are still stored',
    () async {
      final r = refresher((_) async => http.Response(fixture, 200));
      final result = await r.refresh({
        (usd, egp),
        (usd, const Unit('XYZ')),
      }) as RefreshSucceeded;
      expect(result.notCovered, [(usd, const Unit('XYZ'))]);
      expect(result.inserted, 1);
    },
  );

  test('refreshing twice stores nothing new the second time', () async {
    final r = refresher((_) async => http.Response(fixture, 200));
    expect(((await r.refresh({(usd, egp)})) as RefreshSucceeded).inserted, 1);
    expect(((await r.refresh({(usd, egp)})) as RefreshSucceeded).inserted, 0);
    expect((await stored()).length, 1);
  });

  test('numbers in tiny exponent form still parse', () async {
    final r = refresher(
      (_) async => http.Response(
        '{"date":"2026-10-16","usd":{"xau":2.39e-7,"egp":53.4}}',
        200,
      ),
    );
    final result = await r.refresh({(xauG, egp)});
    expect(result, isA<RefreshSucceeded>());
  });
}
