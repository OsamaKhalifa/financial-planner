/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/year_end_reminder.dart';

const _notificationId = 1;

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    'zakat_year_end',
    'Zakat year end',
    icon: '@mipmap/ic_launcher',
  ),
  iOS: DarwinNotificationDetails(),
);

/// The only file that talks to the notification plugin (ADR-0008). The plugin
/// starts on the first call, so app start and every test stay plugin-free.
class LocalYearEndReminder implements YearEndReminder {
  LocalYearEndReminder([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final _taps = StreamController<String>.broadcast();
  Future<void>? _started;

  Future<void> _start() => _started ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
    onDidReceiveNotificationResponse: (r) {
      final payload = r.payload;
      if (payload != null) _taps.add(payload);
    },
  );

  bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Future<bool> requestPermission() async {
    await _start();
    final granted = _ios
        ? await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true)
        : await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
    return granted ?? false;
  }

  @override
  Future<bool> isPermitted() async {
    await _start();
    if (_ios) {
      final options = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      return options?.isEnabled ?? false;
    }
    final enabled = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.areNotificationsEnabled();
    return enabled ?? false;
  }

  /// The instant is built from device wall time and sent as UTC: `tz.UTC`
  /// needs no time-zone database, and the app schedules again at every start
  /// (ADR-0008). Inexact on Android: no exact-alarm permission.
  @override
  Future<void> schedule(Reminder r) async {
    await _start();
    await _plugin.zonedSchedule(
      id: _notificationId,
      title: r.title,
      body: r.body,
      scheduledDate: tz.TZDateTime.from(r.fireAt.toUtc(), tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: r.yearKey,
    );
  }

  @override
  Future<void> cancel() async {
    await _start();
    await _plugin.cancel(id: _notificationId);
  }

  @override
  Future<String?> launchYearKey() async {
    await _start();
    final launch = await _plugin.getNotificationAppLaunchDetails();
    return launch != null && launch.didNotificationLaunchApp
        ? launch.notificationResponse?.payload
        : null;
  }

  @override
  Stream<String> get taps => _taps.stream;
}
