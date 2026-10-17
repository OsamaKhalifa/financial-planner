/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../ids.dart';
import '../../reference/units.dart';

enum RateSource { typed, currencyApi }

final _epoch = DateTime.utc(1970);

final class Rate {
  Rate({
    String? id,
    required this.from,
    required this.to,
    required this.rate,
    required this.asOf,
    this.source = RateSource.typed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? newId(),
       createdAt = createdAt ?? _epoch,
       updatedAt = updatedAt ?? createdAt ?? _epoch;

  final String id;
  final Unit from;
  final Unit to;
  final Decimal rate;
  final DateTime asOf;
  final RateSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
}
