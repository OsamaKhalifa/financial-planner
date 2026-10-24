/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

/// The one pending year-end notification (ADR-0008).
final class Reminder {
  const Reminder({
    required this.yearKey,
    required this.fireAt,
    required this.title,
    required this.body,
  });

  /// The computed due date of the year, `yyyy-MM-dd`; the tap payload.
  final String yearKey;

  /// Device wall time.
  final DateTime fireAt;
  final String title;
  final String body;
}

abstract interface class YearEndReminder {
  /// Shows the OS prompt; the caller decides when (AC-34).
  Future<bool> requestPermission();

  /// Read at every sync: the user can change it in the phone settings.
  Future<bool> isPermitted();

  /// Replaces the one pending reminder.
  Future<void> schedule(Reminder r);

  Future<void> cancel();

  /// The year key of the notification that opened the app, if any.
  Future<String?> launchYearKey();

  /// Year keys of notifications tapped while the app runs.
  Stream<String> get taps;
}
