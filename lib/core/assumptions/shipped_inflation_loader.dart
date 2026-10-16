/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/services.dart';

import 'domain/inflation.dart';

const shippedInflationAsset = 'assets/inflation/cpi_annual.json';

Future<ShippedInflation> loadShippedInflation(AssetBundle bundle) async =>
    ShippedInflation.parse(await bundle.loadString(shippedInflationAsset));
