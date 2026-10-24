/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:async';

import 'package:financial_planner/features/zakat/domain/year_end_reminder.dart';

/// Records what the app asks of the phone; no platform channel, no network.
class FakeYearEndReminder implements YearEndReminder {
  FakeYearEndReminder({this.permitted = true, this.launchKey});

  /// What the phone answers to [isPermitted] and what [requestPermission]
  /// grants.
  bool permitted;
  String? launchKey;

  int permissionRequests = 0;

  /// Every call to [schedule], in order.
  final List<Reminder> scheduled = [];
  int cancels = 0;
  final _taps = StreamController<String>.broadcast();

  /// The one pending reminder: a new one replaces the old, cancel removes it.
  Reminder? pending;

  void tap(String yearKey) => _taps.add(yearKey);

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permitted;
  }

  @override
  Future<bool> isPermitted() async => permitted;

  @override
  Future<void> schedule(Reminder r) async {
    scheduled.add(r);
    pending = r;
  }

  @override
  Future<void> cancel() async {
    cancels++;
    pending = null;
  }

  @override
  Future<String?> launchYearKey() async => launchKey;

  @override
  Stream<String> get taps => _taps.stream;
}
