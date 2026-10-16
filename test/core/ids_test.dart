/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('newId is a UUID v4 and differs each call', () {
    final id = newId();
    expect(
      RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
          .hasMatch(id),
      isTrue,
    );
    expect(newId(), isNot(id));
  });
}
