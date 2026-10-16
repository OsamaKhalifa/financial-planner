/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter_test/flutter_test.dart';

import 'support/golden_path.dart';

/// The same flow as integration_test/golden_path_test.dart, headless, so every
/// pull request exercises it (CI has no simulator).
void main() {
  testWidgets(
    'golden path: set up, add, record, update all, April view',
    runGoldenPath,
  );
}
