/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter_test/flutter_test.dart';

import 'support/golden_path.dart';

/// Yasmin's zakat year through the real app, headless, so every pull request
/// exercises it (CI has no simulator). Same flow as
/// integration_test/golden_path_zakat_test.dart.
void main() {
  testWidgets(
    'golden path: notification opens the year, start, EGP and USD entries, settled, history',
    runZakatGoldenPath,
  );
}
