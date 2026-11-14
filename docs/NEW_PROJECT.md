# Starting a New Project from This Template

A checklist for turning this template into a real app. Work through it top to
bottom: the early steps (identity) are the hardest to change later, and the
last step tells you if anything was missed.

Tick the boxes as you go. Skip a section only when the note says it's optional.

---

## 1. Get a clean copy

- [ ] Create the new repository:
  - **GitHub:** open the template repo → **Use this template** → **Create a new repository**, or
  - **Manually:** clone it, delete the `.git` folder, then `git init`.
- [ ] Run `flutter pub get`, then `flutter test`. Everything should pass
      before you change anything, so later failures are yours to fix, not
      leftovers.
- [ ] Check `FLUTTER_VERSION` in `.github/workflows/flutter-ci.yml` matches
      your local `flutter --version`.

---

## 2. App identity

These are baked into store listings and signing. Change them **before** the
first store upload or Firebase setup.

- [ ] **Bundle ID / application ID** (e.g. `com.yourcompany.yourapp`):

  ```bash
  dart run rename setBundleId --value "com.yourcompany.yourapp"
  ```

- [ ] **App name** shown under the launcher icon:

  ```bash
  dart run rename setAppName --value "Your App"
  ```

- [ ] Check what `rename` didn't touch. Fix every remaining hit by hand:

  ```bash
  grep -rn "com.example.template\|Flutter Template" android ios macos linux windows web
  ```

  The usual places are the `namespace` in `android/app/build.gradle.kts`, the
  folder of `MainActivity.kt` (`android/app/src/main/kotlin/com/example/template/`,
  which must match the new package), and `web/manifest.json` / `web/index.html`.

- [ ] **In-app name**: the `AppStrings.appName` value in all three
      `lib/core/localization/langs/*.dart` files.
- [ ] **`pubspec.yaml`**: `description`, and `version` (keep `1.0.0+1` for
      the first release; CI sets the build number).
- [ ] *Optional:* **Dart package name**. Change `name: template` in
      `pubspec.yaml` to your app's `snake_case` name, then replace
      `package:template/` with `package:your_app/` in `lib/` and `test/`
      (VS Code: *Search → Replace All*). Run `flutter pub get` afterwards.

---

## 3. Platforms

- [ ] Delete the folders of platforms you won't ship (`web/`, `windows/`,
      `linux/`, `macos/`). Less to maintain, and fewer places for old names
      to hide.
- [ ] Shipping **macOS**? Add `com.apple.security.network.client` to both
      `macos/Runner/*.entitlements`, or no request will go out.
- [ ] Shipping **web**? Tokens can't be stored securely in a browser. Review
      the token storage before going live (see README → Known Limitations).

---

## 4. Branding

- [ ] **Colors**: `lib/core/theme/app_colors.dart` (light and dark values).
- [ ] **Font**: `lib/core/theme/app_theme.dart` (`GoogleFonts.poppins(...)`).
- [ ] **Design size**: `412 × 917` in `lib/app.dart`, if your designs use another frame.
- [ ] **App icon**: [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons).
- [ ] **Native splash**: [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash).
- [ ] **Onboarding**: replace `assets/illustrations/onboarding_*.svg` and the
      `onboarding*` strings, or remove onboarding entirely (see step 5).

---

## 5. Remove the demo content

The template ships a working demo so every pattern has an example. Keep
`features/home/` as a reference until your first real data screen works, then
delete what you don't use.

| Demo piece | Where | What to do |
| --- | --- | --- |
| Post feed (list, create post, likes) | `lib/features/home/` (controller, repository, `HomePost`, `home_*` widgets) | Replace with your home screen. `HomeController` has hardcoded demo values (`'Travel'`, `/images/posts/3.jpg`, …). |
| Demo endpoints | `ApiEndpoints.posts`, `ApiEndpoints.postsNewestFirst` | Delete with the feed. |
| Placeholder user name | `userName` in `MainController` and `ProfileController` | Replace with the logged-in user's data. |
| Placeholder avatar | `assets/images/profile_avatar.jpg` (`ImagePath.profileAvatar`) | Replace with the user's photo (`CustomNetworkImage`). |
| Unused product images | `assets/images/product_*.png` and their `ImagePath` constants | Delete. Nothing uses them. |
| "Coming soon" tabs | `features/search/`, `features/notification/`, `features/settings/` | Build them, or remove the tab from `MainController.tabs`, its screen from `MainScreen`, its binding from `MainBinding`, and the feature folder. |
| Profile menu | `features/profile/view/profile_screen.dart` | Only notifications, theme and language work; the other rows don't open anything yet. Wire or remove them. |
| Login screen links | `features/auth/view/login_screen.dart` | *Forgot password*, *Sign up* and the social buttons (`AuthSocialButton`) have empty `onTap`s. Wire them or remove them. |
| Screenshots | `docs/screenshots/` and the README table | Replace with your app's, or delete. |

After deleting, remove any `AppStrings` keys that are no longer used, from
`app_strings.dart` **and** all three language files.

Keep `DevScenario` and the ⚙ dev switcher. They only exist in debug builds.

---

## 6. Backend

See README → **Connecting Your Backend** for the formats the app expects.

- [ ] **Base URLs** in `lib/core/config/env_config.dart`. `dev` and `staging`
      point at the template's public mock server. Replace all three.
- [ ] **Response format**: compare your API's success, error and refresh
      responses with the README. Adjust `NetworkCaller._handleResponse` and
      `_performRefresh` if they differ.
- [ ] **Unauthenticated requests must return `401`**, not `403`, or the app
      won't refresh the token or send the user to login.
- [ ] **Login**: add an `AuthRepository` and wire the Sign in button
      (README → *Wiring up login*).
- [ ] **Logout**: if the backend has a logout endpoint, call it in
      `ProfileController.logout()` before `clearAuth()`.
- [ ] Add every endpoint as a getter in `ApiEndpoints`.

---

## 7. Languages

The template ships English, Bengali and Arabic (RTL).

- [ ] Keep the ones you need. To **remove** one:
  1. Delete `lib/core/localization/langs/<lang>.dart` and its entry in `AppTranslations`.
  2. Remove its `Locale` from `supportedLocales` and the locale `switch` in `lib/app.dart`.
  3. Remove its code from `StorageKeys`, `SettingsUtil.changeLanguage` and the list in `LanguageController`.
  4. Delete its `AppStrings.language*` key from `app_strings.dart` and the remaining language files.
- [ ] Only one language left? Remove the language row from the profile
      screen and the `/language` route.
- [ ] To **add** one, follow README → *Adding a language*.

---

## 8. Permissions & privacy

- [ ] The template declares only network permissions. Add others only when
      a feature needs them (README → *Permissions*).
- [ ] Write a **privacy policy**. Both stores require one.
- [ ] Fill in **Google Play → Data safety** and **App Store → App Privacy**
      for everything the app collects.

---

## 9. Release setup

- [ ] **Android upload key**: create a keystore and keep it somewhere safe
      (losing it means you can't update the app):

  ```bash
  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```

- [ ] **CI secrets** in GitHub → *Settings → Secrets and variables → Actions*:
      `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
      `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` (README → *CI/CD*).
- [ ] **iOS**: set the team and signing in Xcode. The CI builds Android only.
- [ ] *Optional:* **crash reporting**: follow [`CRASHLYTICS.md`](CRASHLYTICS.md).
      Recommended before the first public release.

---

## 10. Repository housekeeping

- [ ] **README**: rewrite it for your app. Keep the sections your team needs
      (setup, backend, CI) and drop the template pitch.
- [ ] **LICENSE**: the template is MIT with the template author's copyright.
      Replace it with your own license, or remove it for a private/client app.
- [ ] **`AGENTS.md` and `docs/ARCHITECTURE.md`**: keep them; they hold the
      coding rules. Update the tech stack if you swapped a package. If you
      deleted `features/home/`, replace the examples that point to it
      (`features/home/`, `HomeFeed`, `HomePostSkeleton` in AGENTS.md Layer
      Rule 9 and in ARCHITECTURE.md §3.3) with your own first data screen.
- [ ] Remove this file (`docs/NEW_PROJECT.md`) once you're done, or keep it
      as a record.

---

## 11. Final check

- [ ] Nothing from the template is left:

  ```bash
  grep -rni "com.example\|Flutter Template\|Tonmoy\|mock-server\|api.example.com" --exclude-dir=build --exclude-dir=.dart_tool .
  ```

  Only matches in files you intentionally kept (like this checklist) are OK.

- [ ] `dart format lib test`, `flutter analyze` and `flutter test` are clean.
- [ ] `flutter run --release --dart-define=ENV=staging` on a real device:
      onboarding → login → main → logout works, in light and dark mode, and
      in every language you kept.
- [ ] Push to `dev` and check that the CI run is green.
