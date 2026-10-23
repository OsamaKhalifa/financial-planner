/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/features/export/data/google_sheets_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financial_planner/features/export/export_providers.dart';

/// Stands in for Google sign-in, which has no fake of its own.
class FakeGoogleAccount extends GoogleAccountNotifier {
  FakeGoogleAccount({this.email, this.linkError, this.tokens = const ['t1']});

  String? email;
  final String? linkError;

  /// Handed out in order; the last one repeats.
  final List<String> tokens;
  final forgotten = <String>[];
  var _next = 0;

  @override
  Future<String?> build() async => email;

  @override
  Future<void> link() async {
    if (linkError != null) throw ExportFailed(linkError!);
    email = 'owner@example.com';
    state = AsyncData(email);
  }

  @override
  Future<void> unlink() async {
    email = null;
    state = const AsyncData(null);
  }

  @override
  Future<String> accessToken() async =>
      tokens[_next < tokens.length ? _next++ : tokens.length - 1];

  @override
  Future<void> forgetToken(String token) async => forgotten.add(token);
}
