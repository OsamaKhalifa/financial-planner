# ADR-0008 — Year-end reminder with `flutter_local_notifications`, behind one small port

**Status:** proposed · 2026-10-24 · architect · versions and setup read from pub.dev and the 22.3.1 package source on 2026-10-23; resolution checked with `flutter pub add --dry-run` against the current `pubspec.lock`. **Not yet run on a device.**

## Decision

The one zakat year-end notification (story §5.4) is scheduled with **`flutter_local_notifications` 22.3.1** plus **`timezone` 0.11.1** (direct, because we import it), behind a small interface `YearEndReminder` in `lib/features/zakat/domain/year_end_reminder.dart`. One implementation, `LocalYearEndReminder` (`lib/features/zakat/data/local_year_end_reminder.dart`), is the only file that imports the plugin. Tests use `FakeYearEndReminder` (`test/support/fake_year_end_reminder.dart`): no platform channel in any test.

### The port

```dart
final class Reminder { String yearKey; DateTime fireAt /* local wall time */; String title; String body; }
abstract interface class YearEndReminder {
  Future<bool> requestPermission();     // shows the OS prompt; the caller decides when (AC-34)
  Future<bool> isPermitted();           // read at every sync; the user can change it in phone settings
  Future<void> schedule(Reminder r);    // replaces the one pending reminder (fixed id 1)
  Future<void> cancel();
  Future<String?> launchYearKey();      // app opened from the notification (cold start)
  Stream<String> get taps;              // tapped while the app is running
}
```

"At most one notification" (AC-37) holds by construction: one fixed id, `schedule` = replace.

### Scheduling choices

- **Android: `AndroidScheduleMode.inexactAllowWhileIdle`.** No exact-alarm permission: `SCHEDULE_EXACT_ALARM` is off by default for new installs on Android 14+ and needs a trip to a system settings page; `USE_EXACT_ALARM` is reserved by Play policy for alarm-clock and calendar apps. The story needs "a reminder on the due date", not to-the-minute delivery. Cost: Android may deliver it later than 09:00 (OS batching; amount not measured). iOS delivers on time. Owner question Q-N1 in the spec.
- **No `flutter_timezone`.** The fire moment is built as a local `DateTime(y, m, d, hh, mm)` (Dart applies the device's zone and DST for that date), converted `.toUtc()`, and passed as `tz.TZDateTime.from(utc, tz.UTC)`. `tz.UTC` needs no time-zone database (read in `timezone` 0.11.1 `lib/src/env.dart`), and the plugin sends the zone name `Etc/UTC` to both platforms. The app re-schedules at every start, so after a time-zone change the next start corrects the hour. Never call `tz.local` (it is `late` and unset).
- **iOS init asks nothing:** `DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false)`. The prompt comes only from `requestPermission()` (AC-34). Android 13+: `requestNotificationsPermission()`; Android ≤ 12 returns true.
- **Payload** = the year key (the computed due date, `yyyy-MM-dd`). Tap → Zakat tab → that year (AC-36).
- Android channel `zakat_year_end`, default importance, no sound change; icon `@mipmap/ic_launcher`.

### Versions (two-week rule: published before 2026-10-10)

| Package | Version | Published | Note |
|---|---|---|---|
| `flutter_local_notifications` | **22.3.1** | 2026-09-13 | 22.3.2 (2026-10-12) is too new. Needs Dart ^3.10, Flutter ≥ 3.38.1 — we have 3.13.5 / 3.47.7. |
| `timezone` | **0.11.1** | 2026-06-29 | 0.11.2 (2026-10-12) too new. Plugin needs ^0.11.0. |
| transitive: `_platform_interface` 12.2.0, `_web` 1.0.0, `_windows` 3.1.1, `dbus` 0.8.0, `xml` 7.0.1, `petitparser` 7.0.2 | | all before 2026-10-10 | |
| transitive: `flutter_local_notifications_linux` 8.0.2 | | 2026-10-12 | **Too new by the rule**, but Linux-only: not compiled into iOS/Android builds. Accept, or pin `8.0.1` under `dependency_overrides` until 2026-10-26. Developer's choice; say which in the PR. |

`flutter pub add flutter_local_notifications:22.3.1 timezone:0.11.1 hijri:3.0.1 --dry-run` on the current lock: resolves, changes 10 packages (the list above + `hijri`), no existing package moves.

### Native file changes (the full list)

**`android/app/build.gradle.kts`** — the plugin needs core-library desugaring (README "Gradle setup"):
```kotlin
android { compileOptions { isCoreLibraryDesugaringEnabled = true } }   // keep the existing Java 17 lines
dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5") }   // latest on Google Maven; README shows 2.1.4
```
AGP is already 9.1.0 (≥ 8.11.1 required). minSdk: plugin needs 24; `flutter.minSdkVersion` is 24 on Flutter 3.47.7 (read in `FlutterExtension.kt`) — no change. compileSdk must be ≥ 35: `flutter.compileSdkVersion` is used; the first `flutter build apk` in the PR confirms it (the plugin's AAR check fails the build otherwise).

**`android/app/src/main/AndroidManifest.xml`** — `POST_NOTIFICATIONS` and `VIBRATE` come from the plugin's own manifest. We add:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>   <!-- re-schedule after a reboot -->
<!-- inside <application> -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
    <action android:name="android.intent.action.QUICKBOOT_POWERON" />
    <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
  </intent-filter>
</receiver>
```
**No** `SCHEDULE_EXACT_ALARM`, **no** `USE_EXACT_ALARM`, no full-screen intent, no foreground service.

**`android/app/src/main/res/raw/keep.xml`** (new) — so release resource shrinking keeps the notification icon (README "Release build configuration"):
```xml
<resources xmlns:tools="http://schemas.android.com/tools" tools:keep="@mipmap/ic_launcher" />
```

**`ios/Runner/AppDelegate.swift`** — one line in `didFinishLaunchingWithOptions`, before `super`:
```swift
UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
```
(Matches the plugin example for the implicit-engine `AppDelegate` the project already uses. No action isolate → no `setPluginRegistrantCallback`.) No `Info.plist` key is needed for local notifications.

## Why

Owner decision 2026-10-23: one local notification per zakat year, no server, no background work. Scheduling a future local notification needs native code on both platforms; this is the maintained, widely used plugin for it.

**Why a port:** the plugin talks over a platform channel that does not exist in `flutter test`. With the port, every scheduling AC (AC-34…AC-40, AC-44) is a unit or widget test against a fake that records `schedule` / `cancel` calls. This is a second exception to "no interface with one implementation", justified the same way as ADR-0001: the second caller (the fake) is real and used by every test, not speculative. It is not extended to anything else.

**Weight:** the plugin's Android part is a small Java library + Gson; iOS uses the system `UserNotifications` framework. Measure once with `flutter build apk --analyze-size` in the PR, do not guess.

## Rejected alternatives

- **`awesome_notifications` 0.12.1** — larger API (own permission screens, foreground services), own native setup; last release 2026-07, smaller user base on our Flutter version.
- **Our own method channel** (`UNUserNotificationCenter` / `AlarmManager` + `NotificationManager`) — two native code bases, boot receiver and permission handling written and tested by us.
- **Exact alarms** (`exactAllowWhileIdle` + `SCHEDULE_EXACT_ALARM`) — a second permission flow on Android 14+ for minute precision the story does not need.
- **`flutter_timezone` 5.1.1 + `tz.setLocalLocation`** — one more plugin with native code to get the zone name, only to follow a mid-year time-zone change before the next app start.
- **`matchDateTimeComponents` yearly repeat** — Hijri dates move ~11 days a year; a repeating Gregorian notification would be wrong after one year.

## Trigger to revisit

- Owner or users report the Android reminder arriving too late to be useful → switch to exact alarms with the permission flow.
- A second notification kind is approved (story §12 says none) → the port may become a general one.
- `flutter_local_notifications` 23 (in dev now) ships a breaking change we need, or the plugin is discontinued.
