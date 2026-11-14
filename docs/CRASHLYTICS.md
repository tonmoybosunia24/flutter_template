# Adding Firebase Crashlytics

This template ships **without** crash reporting. A release build logs nothing
(`AppLogger` is debug-only), so if the app crashes on a user's phone, you never
find out. This guide adds [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
to an app built from the template, step by step.

When you're done:

- Every uncaught error (in `build()`, layout, gestures, `Future`s, timers or plugins) is reported as a crash.
- Every `AppLogger.logError(...)` call (repositories, `NetworkCaller`, splash, …) is reported as a **non-fatal** error, with no changes at the call sites.
- Reports are tagged with the environment (`dev` / `staging` / `prod`) and the signed-in user's id.
- Nothing is sent from debug runs or `ENV=dev` builds, and unit tests keep working without Firebase.

> **Platforms:** Crashlytics supports Android, iOS and macOS. On web, Windows and
> Linux, `CrashReporter` does nothing, so the app still runs there.

---

## Contents

1. [How it fits together](#1-how-it-fits-together)
2. [Prerequisites](#2-prerequisites)
3. [Create the Firebase project](#3-create-the-firebase-project)
4. [Add the packages](#4-add-the-packages)
5. [Connect the app with `flutterfire configure`](#5-connect-the-app-with-flutterfire-configure)
6. [Check the native setup](#6-check-the-native-setup)
7. [Add `CrashReporter`](#7-add-crashreporter)
8. [Start it in `main.dart`](#8-start-it-in-maindart)
9. [Report logged errors from `AppLogger`](#9-report-logged-errors-from-applogger)
10. [Tag reports with the user](#10-tag-reports-with-the-user)
11. [CI/CD](#11-cicd)
12. [Test it](#12-test-it)
13. [Privacy & store forms](#13-privacy--store-forms)
14. [Optional: obfuscated builds](#14-optional-obfuscated-builds)
15. [Update the project rules](#15-update-the-project-rules)
16. [Troubleshooting](#16-troubleshooting)

---

## 1. How it fits together

```text
Error happens
   │
   ├─ Caught by try/catch and logged ─► AppLogger.logError ─┐
   │                                                        │
   ├─ Inside build/layout/gesture ─► FlutterError.onError ──┤
   │                                                        ├─► CrashReporter ─► Crashlytics console
   └─ Uncaught async/Future/plugin ─► PlatformDispatcher ───┘                    (+ email alerts)
                                      .instance.onError
```

Only **one file** in the app talks to Firebase: `lib/core/utils/crash_reporter.dart`.
Everything else calls `CrashReporter` or `AppLogger`. If a client later wants
Sentry instead, you rewrite that one file and nothing else.

### Files you will touch

| File | Change |
|---|---|
| `pubspec.yaml` | `firebase_core`, `firebase_crashlytics` |
| `lib/firebase_options.dart` | **Generated** by `flutterfire configure` |
| `android/app/google-services.json` | **Generated** |
| `ios/Runner/GoogleService-Info.plist` | **Generated** |
| `android/settings.gradle.kts`, `android/app/build.gradle.kts` | Two Gradle plugins (usually added by `flutterfire configure`) |
| `lib/core/utils/crash_reporter.dart` | **New** – the wrapper |
| `lib/core/core.dart` | Export the wrapper |
| `lib/main.dart` | `await CrashReporter.init()` |
| `lib/core/utils/logger.dart` | Forward `logError` to `CrashReporter` |
| `lib/core/network/network_caller.dart` | Clear the user on logout |
| Your login code | Set the user after sign-in |
| `AGENTS.md`, `docs/ARCHITECTURE.md` | Document the rule |

---

## 2. Prerequisites

- A Google account with access to the [Firebase console](https://console.firebase.google.com/).
- **Rename the app first.** Firebase registers your Android `applicationId` and
  iOS bundle ID. If they are still `com.example.template`, rename them now (see
  [Rename & Rebrand](../README.md#-rename--rebrand) in the README), or you'll
  have to register the app again later.
- Firebase CLI and FlutterFire CLI:

```bash
npm install -g firebase-tools        # Firebase CLI (needs Node.js)
firebase login
dart pub global activate flutterfire_cli
```

Make sure the Dart pub global `bin` folder is on your `PATH`, so `flutterfire` works in a new terminal.

---

## 3. Create the Firebase project

1. In the Firebase console, click **Add project**. Give it the app's name.
   Google Analytics is optional for Crashlytics.
2. Open **Build → Crashlytics** in the left menu and click **Enable Crashlytics**.
   The dashboard stays empty until the first report arrives (step 12).

> **One project or one per environment?** This template picks the environment
> with `--dart-define=ENV=...` and uses a single `applicationId`, so the simple
> setup is **one Firebase project for all environments**. `CrashReporter` tags
> every report with `environment`, so you can filter by it in the console, and
> `dev` builds don't send anything anyway. Use separate projects only after
> adding real Gradle/Xcode flavors with separate app IDs.

---

## 4. Add the packages

```bash
flutter pub add firebase_core firebase_crashlytics
```

---

## 5. Connect the app with `flutterfire configure`

From the project root:

```bash
flutterfire configure
```

- Pick the Firebase project you created.
- Select only **android** and **ios** (add **macos** if you ship it).

This:

- generates `lib/firebase_options.dart`
- downloads `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`
- adds the Google Services and Crashlytics Gradle plugins, because `firebase_crashlytics` is in `pubspec.yaml`
- adds an Xcode build phase that uploads iOS debug symbols (dSYMs) to Crashlytics

Run it again whenever you add a platform or change the bundle ID.

> **Should these files be committed?** Yes. `firebase_options.dart`,
> `google-services.json` and `GoogleService-Info.plist` hold project
> identifiers, not secrets, and CI needs them to build. Protect the project
> with Firebase security rules and API key restrictions instead.

---

## 6. Check the native setup

`flutterfire configure` usually does all of this. Check it, and add anything that's missing.

### Android

`android/settings.gradle.kts`, in the `plugins { }` block:

```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
    // Added for Firebase. Use the versions flutterfire wrote, or the latest from the Firebase docs.
    id("com.google.gms.google-services") version "<version>" apply false
    id("com.google.firebase.crashlytics") version "<version>" apply false
}
```

`android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
```

If the build fails with a `minSdk` error, raise `minSdk` in `defaultConfig` to
the version the error asks for.

### iOS

- `ios/Runner/GoogleService-Info.plist` must be **inside the Runner target**.
  Open `ios/Runner.xcworkspace` in Xcode and check that the file shows under
  *Runner* with *Target Membership → Runner* ticked.
- In *Runner → Build Phases*, there should be a phase named like
  **"FlutterFire: flutterfire upload-crashlytics-symbols"**. Without it, iOS
  crashes show memory addresses instead of file names and line numbers.
- *Build Settings → Debug Information Format* should be
  **DWARF with dSYM File** for Release (the default).
- If CocoaPods complains about the deployment target, raise the iOS version in
  `ios/Podfile` and in Xcode (*Runner → General → Minimum Deployments*) to the
  one in the error.

### macOS (only if you ship it)

Add outgoing network access to **both** `macos/Runner/DebugProfile.entitlements`
and `macos/Runner/Release.entitlements`, or reports can't be sent:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

---

## 7. Add `CrashReporter`

Create `lib/core/utils/crash_reporter.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:template/core/config/env_config.dart';
import 'package:template/firebase_options.dart';

/// Sends crashes and logged errors to Firebase Crashlytics. Sends nothing from debug runs or dev builds, and does nothing on platforms Crashlytics doesn't support or before [init] has run.
class CrashReporter {
  CrashReporter._();

  // True once init() has finished. Calls made before that (or in unit tests) are ignored instead of throwing.
  static bool _isReady = false;

  // Crashlytics only runs on Android, iOS and macOS.
  static bool get _isSupported =>
      !kIsWeb &&
      const [
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);

  // Starts Firebase and Crashlytics and catches every uncaught Flutter and async error. Call once in main(), before runApp.
  static Future<void> init() async {
    if (!_isSupported) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(
        !kDebugMode && !EnvConfig.isDev,
      );
      await crashlytics.setCustomKey('environment', EnvConfig.environment.name);

      // Errors in build, layout, paint and gesture callbacks. Still printed to the console in debug.
      FlutterError.onError = crashlytics.recordFlutterFatalError;

      // Uncaught errors from Futures, timers and plugins. Returning true marks them as handled.
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
      _isReady = true;
    } catch (e, stackTrace) {
      // A broken Firebase setup must never stop the app from starting.
      debugPrintStack(label: 'CrashReporter init failed: $e', stackTrace: stackTrace);
    }
  }

  // Reports an error the app caught and survived (non-fatal). [reason] shows above the stack trace in the console.
  static void recordError(Object error, [StackTrace? stackTrace, String? reason]) {
    if (!_isReady) return;
    FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
  }

  // Tags later reports with the signed-in user's id. Pass null on logout.
  static void setUser(String? userId) {
    if (!_isReady) return;
    FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
  }
}
```

> `debugPrintStack` is used instead of `AppLogger` because `AppLogger.logError`
> calls `CrashReporter` (step 9). The architecture test bans `debugPrint(`
> but not `debugPrintStack`. If you'd rather not use it, drop the line and
> leave the `catch` empty.

Export it from `lib/core/core.dart`, next to the other utilities:

```dart
export 'utils/crash_reporter.dart';
```

### Why the guards matter

| Guard | What breaks without it |
|---|---|
| `_isSupported` | Web, Windows and Linux builds throw at startup. |
| `_isReady` | Unit tests call `AppLogger.logError` (for example `network_caller_test.dart`). Without Firebase initialized, `FirebaseCrashlytics.instance` throws and those tests fail. |
| `try/catch` in `init` | A missing `GoogleService-Info.plist` or a wrong config crashes the app on launch. |
| `!kDebugMode && !EnvConfig.isDev` | Your own debugging and every dev build fill the dashboard with noise. |

---

## 8. Start it in `main.dart`

Call `init()` **first**, so errors during the rest of startup are reported too:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CrashReporter.init(); // Crash reporting first, so startup errors are caught too
  await GetStorage.init();
  // ...rest unchanged
  runApp(const MyApp());
}
```

`main.dart` already imports `package:template/core/core.dart`, so no new import is needed.

---

## 9. Report logged errors from `AppLogger`

In `lib/core/utils/logger.dart`, forward `logError` to `CrashReporter`:

```dart
import 'package:template/core/utils/crash_reporter.dart';

// ...

  // Logs an error message along with optional error details and stack trace, and reports it to Crashlytics as a non-fatal error.
  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
    CrashReporter.recordError(error ?? message, stackTrace, message);
  }
```

Every existing `AppLogger.logError(...)` is now a non-fatal report, for example:

- `'Unexpected posts response'`: the API changed its JSON shape and `fromJson` threw.
- `'Token refresh failed'`: the refresh endpoint misbehaves.
- `'Splash startup failed'`: something broke during startup.

Don't send `logInfo`, `logDebug` or `logWarning`. They're too noisy.

> Import `crash_reporter.dart` directly here, not `core.dart`. `core.dart`
> exports `logger.dart`, and importing the barrel from inside it creates a
> cycle.

---

## 10. Tag reports with the user

So you can answer "which user hit this crash?". Send an **id only**, never an
email, name or phone number (see step 13).

**After a successful login**, where you save the tokens (your auth controller or repository):

```dart
CrashReporter.setUser(user.id.toString());
```

**On logout**, in `NetworkCaller._logout()` (`lib/core/network/network_caller.dart`):

```dart
await _storage.clearAuth();
CrashReporter.setUser(null);
_onSessionExpired();
```

Do the same in your manual "Log out" action.

**When a saved session is restored at startup** (the splash goes straight to
`main`), set the id again if you store it locally. Crashlytics doesn't remember
it between launches.

---

## 11. CI/CD

If you committed the generated files (step 5), **no CI changes are needed**.
`flutter-ci.yml` already builds with `--dart-define=ENV=...`:

| Trigger | `ENV` | Crashlytics |
|---|---|---|
| Push to `dev` | `dev` | off |
| Push to `main` | `staging` | **on** (tagged `staging`) |
| Tag `v*` | `prod` | **on** (tagged `prod`) |

The Crashlytics Gradle plugin also uploads the Android R8 mapping file during
release builds, so native Java/Kotlin stack traces are readable.

If you'd rather **not** commit `google-services.json`, store it base64-encoded
in a repository secret and decode it before the build:

```yaml
      - name: Restore Firebase config
        run: echo "${{ secrets.GOOGLE_SERVICES_JSON_BASE64 }}" | base64 --decode > android/app/google-services.json
```

---

## 12. Test it

Collection is off in debug, so test with a **release build that isn't dev**:

```bash
flutter run --release --dart-define=ENV=staging
```

1. Add a temporary button anywhere, for example on the profile screen:

   ```dart
   onPressed: () => throw StateError('Crashlytics test'),
   ```

2. Tap it. The error goes through `FlutterError.onError`.
3. **Close and reopen the app.** Crashlytics sends reports on the next launch.
4. Within about 5 minutes, the error shows in **Firebase console → Crashlytics**,
   tagged `environment = staging`. The first report also turns on the
   dashboard and email alerts.
5. **Remove the test button.**

To test a native crash (one that kills the app), use
`FirebaseCrashlytics.instance.crash()` instead.

**Nothing shows up?** Turn on verbose logging (Android):

```bash
adb shell setprop log.tag.FirebaseCrashlytics DEBUG
adb logcat -s FirebaseCrashlytics
```

---

## 13. Privacy & store forms

Crash reports are personal data under most store policies.

- **Google Play → App content → Data safety:** declare **App info and
  performance → Crash logs** and **Diagnostics**, plus **Device or other IDs**
  if you call `setUser`. Purpose: *App functionality / Analytics*. Not shared
  with third parties.
- **App Store Connect → App Privacy:** declare **Diagnostics → Crash Data**.
- Mention crash reporting in your **privacy policy**.
- **Opt-in consent (GDPR, children's apps):** start with collection disabled
  and enable it only after the user agrees:

  ```dart
  // In init(): start disabled.
  await crashlytics.setCrashlyticsCollectionEnabled(false);
  // After the user agrees (save the choice through StorageService):
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  ```

- Never put emails, names, phone numbers or tokens in `setUser`,
  `setCustomKey` or error messages.

---

## 14. Optional: obfuscated builds

The template's CI does **not** obfuscate, so Dart stack traces are readable
as they are. If you add `--obfuscate`, Dart stack traces become unreadable
until you upload the symbols:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols --dart-define=ENV=prod

firebase crashlytics:symbols:upload --app=<FIREBASE_ANDROID_APP_ID> build/symbols
```

The Android app ID (`1:1234…:android:abcd…`) is in `lib/firebase_options.dart`.
In CI, the Firebase CLI needs credentials (a service account key in
`GOOGLE_APPLICATION_CREDENTIALS`) for this upload step.

---

## 15. Update the project rules

So every developer and AI agent keeps using it the same way, add this to
`AGENTS.md` (section 1, Tech Stack) and to `docs/ARCHITECTURE.md`:

```markdown
- **Crash reporting**: `CrashReporter` (`lib/core/utils/crash_reporter.dart`) is the only file that imports Firebase Crashlytics. Report caught errors with `AppLogger.logError(message, error, stackTrace)` (it forwards them as non-fatal); call `CrashReporter.setUser(id)` after login and `CrashReporter.setUser(null)` on logout. Never send personal data.
```

Then run the usual checks:

```bash
flutter analyze
flutter test
```

---

## 16. Troubleshooting

| Problem | Fix |
|---|---|
| `[core/no-app] No Firebase App '[DEFAULT]' has been created` | Something called `FirebaseCrashlytics.instance` directly. Go through `CrashReporter`, whose `_isReady` guard prevents this. |
| `File google-services.json is missing` | Run `flutterfire configure` again, or restore the file in CI (step 11). |
| iOS crashes show addresses, no file/line | The dSYM upload build phase is missing or failed. Check step 6 and the Xcode build log. |
| Nothing in the console after testing | You tested a debug or `ENV=dev` build, or didn't reopen the app. See step 12. |
| Web/desktop build fails after adding Firebase | Check that `init()` returns early through `_isSupported`, and that `flutterfire configure` didn't add platforms you don't ship. |
| Tests fail with Firebase errors | A test reached Firebase without `_isReady`. Keep every Crashlytics call inside `CrashReporter`. |
