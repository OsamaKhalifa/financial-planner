/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/features/investments/domain/formulas.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';

/// Flat views for tests. They throw for an excluded item (no base figures)
/// or an unavailable grams view, so production code must not use them.
extension ItemFiguresView on ItemFigures {
  DietzResult get dietz => base!.dietz;
  Decimal get setAside => base!.z;
  Decimal? get returnAfterSetAside => base!.rz;
  PeriodInflation? get inflation => base!.inflation;
  Decimal? get realBeforeZakat => base!.real;
  Decimal? get realAfterSetAside => base!.realAfterZakat;
  PurchasingPower? get purchasingPower => base!.pp;
  DietzResult get unitDietz => itemUnit!.dietz;
  PeriodInflation? get ownInflation => itemUnit!.inflation;
  Decimal? get ownMarketReal => itemUnit!.real;
}

extension PortfolioFiguresView on PortfolioFigures {
  bool get staleRate => staleRates.isNotEmpty;
  DietzResult get dietz => totals!.dietz;
  Decimal get setAside => totals!.z;
  Decimal? get returnAfterSetAside => totals!.rz;
  PeriodInflation? get inflation => totals!.inflation;
  Decimal? get realBeforeZakat => totals!.real;
  Decimal? get realAfterSetAside => totals!.realAfterZakat;
  PurchasingPower? get purchasingPower => totals!.pp;
}
