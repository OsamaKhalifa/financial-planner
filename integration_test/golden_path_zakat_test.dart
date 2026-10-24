/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/golden_path.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'golden path: notification opens the year, start, EGP and USD entries, settled, history',
    runZakatGoldenPath,
  );
}
