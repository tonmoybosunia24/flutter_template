# Project Architecture & Coding Guidelines

This document defines the architecture, folder structure, design system, and coding conventions for this Flutter starter template. It is the long-form reference; the compact rules that AI agents load automatically live in the root `AGENTS.md`.

---

## 1. Tech Stack & Core Packages

- **SDK & Framework**: Flutter (Material 3 enabled), Dart `^3.13.7`
- **State Management, DI & Routing**: `get` (`GetX`)
- **Local & Secure Storage**:
  - `get_storage`: Fast key-value storage for non-sensitive preferences (theme, language, onboarding flag, token expiry timestamp).
  - `flutter_secure_storage`: Encrypted storage for `access_token` and `refresh_token`.
- **Networking**: `http` + `connectivity_plus` wrapped in a custom `NetworkCaller` with automatic token refresh, 401 retry, and unified `ResponseData<T>` / `AppError` handling.
- **Responsive UI**: `flutter_screenutil` (base design size: `412 x 917`) + custom `AppSizeClass` adaptive layout helpers.
- **Typography & Assets**: `google_fonts` (`Poppins` and `Urbanist`), `flutter_svg`.
- **Logging**: `logger` wrapped in `AppLogger` (debug-only).

---

## 2. Directory & File Structure

```text
lib/
├── main.dart                          # Entry point: initializes GetStorage, registers StorageService, runs MyApp
├── app.dart                           # Root widget (MyApp): ScreenUtilInit, GetMaterialApp, AppSizeClass.init, themes, locales
├── bindings/
│   └── app_binding.dart               # App-wide permanent dependencies (e.g., NetworkCaller)
├── routes/
│   ├── app_routes.dart                # Static route name constants (AppRoutes)
│   └── app_pages.dart                 # GetPage definitions linking routes, screens, and bindings (AppPages)
├── core/
│   ├── core.dart                      # Barrel file for config, localization, storage, theme, widgets, and utils (NOT network)
│   ├── config/
│   │   └── env_config.dart            # Environment enum (dev, staging, prod) & EnvConfig (--dart-define)
│   ├── localization/
│   │   ├── app_translations.dart      # GetX Translations map (en_US, ar_SA, bn_BD)
│   │   └── langs/
│   │       ├── en_us.dart             # English translations
│   │       ├── bn_bd.dart             # Bengali translations
│   │       └── ar_sa.dart             # Arabic (RTL) translations
│   ├── network/                       # Imported directly (only by repositories, bindings, and network tests)
│   │   ├── api_endpoints.dart         # Centralized API URLs built from EnvConfig.baseUrl
│   │   ├── app_error.dart             # Translatable application error model (AppError)
│   │   ├── network_caller.dart        # HTTP client wrapper with auth headers, token refresh queue & 401 retry
│   │   └── response_data.dart         # Generic result wrapper (ResponseData<T>)
│   ├── storage/
│   │   ├── storage_keys.dart          # Storage key constants & language code constants (StorageKeys)
│   │   └── storage_service.dart       # GetxService wrapping GetStorage & FlutterSecureStorage
│   ├── theme/
│   │   ├── theme.dart                 # Barrel file for theme
│   │   ├── app_colors.dart            # Raw AppColors constants & AppColorScheme ThemeExtension
│   │   └── app_theme.dart             # AppTheme.light, AppTheme.dark & systemOverlayStyle
│   ├── utils/
│   │   ├── app_dimensions.dart        # Design tokens: padding, radius, font, icon, component sizes, borders, spaces
│   │   ├── app_icons.dart             # SVG icon asset paths (IconPath)
│   │   ├── app_illustrations.dart     # SVG/raster illustration asset paths (IllustrationPath)
│   │   ├── app_images.dart            # Raster image asset paths (ImagePath)
│   │   ├── app_size_class.dart        # Responsive system (AppSizeClass) & global scaling/breakpoint helpers
│   │   ├── app_strings.dart           # Translation key constants (AppStrings)
│   │   ├── extensions.dart            # StringExtension & ContextExtension (context.appColors, context.textTheme, etc.)
│   │   ├── logger.dart                # Debug-only logger (AppLogger)
│   │   ├── settings_util.dart         # Runtime theme & locale switching + persistence (SettingsUtil)
│   │   └── validators.dart            # Localized form field validators (AppValidators)
│   └── widgets/
│       ├── widgets.dart               # Barrel file for core reusable widgets
│       ├── custom_app_bar.dart        # Standard & profile-style AppBar
│       ├── custom_app_bar_action.dart # Circular icon button for CustomAppBar
│       ├── custom_button.dart         # Full-width pill ElevatedButton with loading & icon support
│       ├── custom_coming_soon.dart    # Placeholder widget for unfinished features/tabs
│       ├── custom_loader.dart         # Rotating SVG loading indicator
│       ├── custom_network_image.dart  # Network image with themed placeholder & error fallback
│       ├── custom_pill_button.dart    # Compact gradient pill button with SVG icon + text
│       ├── custom_ring_avatar.dart    # Circular avatar inside a primary gradient ring
│       ├── custom_svg_icon.dart       # SvgPicture.asset wrapper with optional color tinting
│       ├── custom_text.dart           # Responsive text widget (scales fontSize with getSp)
│       └── custom_text_field.dart     # Styled TextFormField with prefix/suffix icons & borderless mode
└── features/
    └── <feature_name>/                # Feature-first modular structure
        ├── binding/
        │   └── <feature>_binding.dart
        ├── controller/
        │   └── <feature>_controller.dart
        ├── model/                     # Optional: present when the feature has data models
        │   └── <feature>_<model>.dart
        ├── repository/                # Optional: present when the feature makes network/data calls
        │   └── <feature>_repository.dart
        ├── view/
        │   └── <feature>_screen.dart
        └── widgets/                   # Optional: feature-specific sub-widgets prefixed with <feature>_
            └── <feature>_<widget>.dart
```

---

## 3. Core Architectural Rules

### 3.1. Imports & Barrel Files
- **Core Barrel**: Import `package:template/core/core.dart` to access config, localization, storage, theme, utils, and core widgets in one import.
- **GetX + ContextExtension Conflict**: Whenever a file imports both `package:get/get.dart` and `package:template/core/core.dart` (and uses `context.textTheme` or `context.theme`), hide GetX's extension to prevent ambiguous extension errors:
  ```dart
  import 'package:get/get.dart' hide ContextExtensionss;
  import 'package:template/core/core.dart';
  ```
- **Network Isolation**: `lib/core/network/*` is intentionally **not** exported from `core.dart`. Import network files directly **only** inside `repository/` classes, `app_binding.dart`, or tests. Views and controllers must never call `NetworkCaller` or `ApiEndpoints` directly.

### 3.2. Feature Layering (View → Controller → Repository → NetworkCaller)
1. **Model (`features/<feature>/model/`)**:
   - Plain immutable Dart classes (`final` fields, `const` constructor) with `factory Model.fromJson(Map<String, dynamic> json)` (and `toJson()` if needed).
2. **Repository (`features/<feature>/repository/`)**:
   - Accepts `NetworkCaller? networkCaller` in its constructor for testability, defaulting to `Get.find<NetworkCaller>()`:
     ```dart
     class ExampleRepository {
       final NetworkCaller _caller;

       ExampleRepository({NetworkCaller? networkCaller})
         : _caller = networkCaller ?? Get.find<NetworkCaller>();
     }
     ```
   - Calls `_caller.getRequest(...)`, `postRequest(...)`, etc.
   - Transforms responses using `response.mapData<T>(...)` wrapped in a `try / catch` block that logs parsing errors with `AppLogger.logError(...)` and returns `ResponseData.failure(error: AppError.unknown, statusCode: response.statusCode)`.
   - Takes every request value as a typed named parameter (e.g. `createPost({required String title, required String category})`). Never hardcode request data inside a repository, and don't accept a raw `Map` from callers; this keeps each method reusable from any controller and lets the compiler catch missing fields.
3. **Controller (`features/<feature>/controller/`)**:
   - Extends `GetxController`.
   - Owns all logic and state, including `AnimationController`s (mix in `GetSingleTickerProviderStateMixin` for `vsync`) and placeholder/static values the screen shows or sends (e.g. a user name until login exists).
   - Navigates only as part of logic (after saving data, after resolving the next route). Simple tap navigation stays in the view: `onPressed: () => Get.offAllNamed(AppRoutes.main)`.
   - Retrieves its repository via `Get.find<ExampleRepository>()`.
   - Holds reactive state with `.obs` (`RxBool`, `RxList`, `RxnString`, etc.).
   - Always checks `if (isClosed) return;` after `await` operations before updating state or navigating.
   - Disposes all `TextEditingController`, `PageController`, `ScrollController`, or `Timer` instances inside `onClose()`.
   - Note on naming collisions: If a controller name collides with Flutter's Material library (e.g., `SearchController`), prefix it with `App` (e.g., `AppSearchController`).
4. **Binding (`features/<feature>/binding/`)**:
   - Extends `Bindings`.
   - Registers repositories and controllers with `Get.lazyPut<T>(() => T())` (use `Get.put` only when a controller must run `onReady` immediately without being read by the view, like `SplashController`).
   - If a screen is a tab inside `MainScreen`, register its binding inside `MainBinding.dependencies()` as well.
5. **View & Feature Widgets (`features/<feature>/view/` & `widgets/`)**:
   - Screens extend `GetView<FeatureController>` with a `const` constructor and contain no logic.
   - A feature folder can hold a whole flow, not just one screen: `features/auth/` holds login, register, forgot password, and so on. Each screen in the flow still gets its own controller and binding (e.g. `LoginController` / `LoginBinding`).
   - Extract reusable sections or complex UI blocks into `features/<feature>/widgets/<feature>_<name>.dart` as `StatelessWidget`s (or `GetView<FeatureController>` when tightly coupled to the controller).
   - Never write `_buildXxx()` helper methods that return widgets. Inline the widget in the tree, or make it a separate widget class when it is large or reused.
   - Don't use `StatefulWidget`. The one exception is purely visual animation inside a reusable core widget, such as the spinning `CustomLoader`.
6. **Widget Placement**:
   - Used by one feature only → `features/<feature>/widgets/`, named `<Feature>Xxx` (e.g. `HomePostCard`).
   - Shared across several features → `core/widgets/`, named `Custom*` and exported from `widgets.dart`.
   - Shared only by the tabs of the main shell → `features/main/widgets/` (e.g. `MainAppBar`).
7. **Static vs Dynamic Content**: When static UI sits above a dynamic list, don't add it as item `0` and offset every index. Use `CustomScrollView` with a `SliverToBoxAdapter` for the static part and a `SliverList` for the items.

---

## 4. Design System, Styling & Responsiveness

### 4.1. Colors & Theming (`AppColorScheme`)
- **Never hardcode hex colors (`Color(0x...)`) or `Colors.*` in UI code.**
- **Do not use raw `AppColors.*` in widgets** (except shared shadow constants like `AppColors.cardShadow`, `AppColors.primaryShadow`, `AppColors.bottomNavShadow`, or `AppColors.white` on fixed contrast elements).
- Always read semantic theme colors from `BuildContext`:
  ```dart
  final colors = context.appColors;
  ```
  Available roles on `AppColorScheme`:
  - Brand: `primary`, `onPrimary`, `primaryVariant`, `secondary`, `secondaryVariant`, `primaryGradient`
  - Surfaces: `background`, `surface`, `surfaceVariant`, `elevatedSurface`, `appBar`
  - Lines & Borders: `border`, `outline`, `divider`
  - Text: `textPrimary`, `textSecondary`, `textMuted`, `textHint`
  - Status & Overlays: `success`, `warning`, `error`, `info`, `overlay`, `scrim`
- If a new color token is needed, add Light and Dark variants to `AppColors` and wire them into `AppColorScheme` (`light`, `dark`, `copyWith`, and `lerp`).

### 4.2. Typography & Text (`CustomText`)
- **Always use `CustomText` instead of Flutter's raw `Text` widget.**
- Pass a theme style from `context.textTheme` (`displayLarge`, `displayMedium`, `headlineSmall`, `titleLarge`, `titleMedium`, `titleSmall`, `bodyLarge`, `bodyMedium`, `bodySmall`, `labelLarge`, `labelMedium`, `labelSmall`).
- `CustomText` automatically scales its font size via `getSp(...)`.
- Never pass `fontSize` or `fontWeight` to `CustomText`; choose the theme style that fits instead. Passing `color:` is allowed, but only with a semantic color from `context.appColors` (e.g. `colors.onPrimary` on a button, `colors.error` for an error message).

### 4.3. Dimensions & Responsive Sizing (`AppDimensions` + `AppSizeClass`)
- **No magic numbers**: Every padding, margin, radius, icon size, font size, border width, component height, and spacing value must come from `AppDimensions` (`lib/core/utils/app_dimensions.dart`). Add new constants to `AppDimensions` if a required token does not exist.
- **Scale tokens using the global helper functions** from `app_size_class.dart`:
  - `getWidth(AppDimensions.padding20)` / `getWidth(AppDimensions.space12)` for horizontal dimensions and widths.
  - `getHeight(AppDimensions.space24)` / `getHeight(AppDimensions.buttonHeight)` for vertical dimensions and heights.
  - `getRadius(AppDimensions.radius20)` / `getRadius(AppDimensions.icon24)` for border radii, square icons, and circular avatars.
  - `getSp(AppDimensions.font14)` for raw `TextStyle` font sizes outside `CustomText`.
- **Write the helper inline at every use** (`width: getRadius(AppDimensions.icon24)`). Don't hoist sizes into local variables in `build` (`final size = getRadius(...)`); locals for `colors` and `textTheme` are fine.
- **Responsive Page Constraints**:
  - For standard screens, center and constrain the body for tablet/desktop/TV support:
    ```dart
    Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ...,
        ),
      ),
    )
    ```
  - For social/feed lists, constrain with `BoxConstraints(maxWidth: AppDimensions.feedMaxWidth)`.
  - Use `getValue<T>(mobile: ..., tablet: ..., desktop: ..., tv: ...)` when a layout value needs breakpoint-specific overrides.

### 4.4. Core Reusable Widgets
Always prefer existing core widgets in `lib/core/widgets/` before building custom ones:
- `CustomAppBar` & `CustomAppBarAction`
- `CustomButton` (full-width primary action button with `isLoading` spinner)
- `CustomPillButton` (small gradient pill button with icon)
- `CustomTextField` (form input with `prefixIcon`, `suffixIcon`, `isPassword`, `validator`, `isBorderless`)
- `CustomText`
- `CustomSvgIcon`
- `CustomNetworkImage`
- `CustomRingAvatar`
- `CustomLoader`
- `CustomComingSoon`

### 4.5. Assets (`IconPath`, `IllustrationPath`, `ImagePath`)
- Never write hardcoded asset path strings (e.g., `'assets/icons/...'`) in widgets or controllers.
- Put small single-color UI icons in `assets/icons/`, add their paths to `IconPath` (`lib/core/utils/app_icons.dart`) and render with `CustomSvgIcon`.
  - Tint monochrome icons with `color: colors.textPrimary` (or appropriate semantic color).
  - Leave `color: null` for multi-color brand icons (`facebook`, `google`).
- Put large multi-color artwork (onboarding, empty and error states) in `assets/illustrations/`, add it to `IllustrationPath` (`lib/core/utils/app_illustrations.dart`) and never tint it.
- Put photos and product images in `assets/images/` and add them to `ImagePath` (`lib/core/utils/app_images.dart`).

---

## 5. Localization & Right-to-Left (RTL) Support

### 5.1. Adding Strings
1. Add a static constant key in `AppStrings` (`lib/core/utils/app_strings.dart`) using `snake_case` values grouped by feature.
2. Add the translation entry to **all three** language maps:
   - `lib/core/localization/langs/en_us.dart` (`enUS`)
   - `lib/core/localization/langs/bn_bd.dart` (`bnBD`)
   - `lib/core/localization/langs/ar_sa.dart` (`arSA`)
3. Use `.tr` or `.trParams({'param': value})` when reading the string.
4. Reusable widgets should accept already-translated `String` parameters (unless the widget uses a fixed default like `AppStrings.comingSoon.tr`).

### 5.2. RTL Layout Rules
- Arabic (`ar_SA`) is a supported first-class locale.
- Prefer directional layout primitives whenever start/end alignment matters:
  - `AlignmentDirectional.centerStart` / `AlignmentDirectional.centerEnd` instead of `Alignment.centerLeft` / `Alignment.centerRight`.
  - `EdgeInsetsDirectional.only(start: ..., end: ...)` or `EdgeInsetsDirectional.fromSTEB(...)` instead of `EdgeInsets.only(left: ..., right: ...)`.
- Flip directional icons (`IconPath.backArrow`, `IconPath.arrowRight`) in RTL:
  - Use `flipInRtl: true` on `CustomAppBarAction`, or wrap in:
    ```dart
    Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: ...,
    )
    ```

---

## 6. Storage, Auth & Networking Conventions

- **Storage Keys**: All keys read or written by `StorageService` must be defined as constants in `StorageKeys` (`lib/core/storage/storage_keys.dart`).
- **Theme & Language Changes**: Use `SettingsUtil.changeTheme(...)` and `SettingsUtil.changeLanguage(...)` so changes both update the active UI immediately and persist via `StorageService`.
- **API Endpoints**: Add all endpoint getters to `ApiEndpoints` (`lib/core/network/api_endpoints.dart`), constructed from `baseUrl` (`EnvConfig.baseUrl`).
- **Auth Calls**: When calling login/register endpoints that should not trigger token refresh on `401`, pass `isAuthCall: true` to `NetworkCaller.postRequest(...)`.
- **Token Refresh**: An expired token is refreshed only when one exists; without a token the request goes out unauthenticated. Only a refresh refusal (`400`, `401` or `403`) clears the session and opens login (once, even for parallel requests). Network errors, timeouts and `5xx` keep the session and return `noInternet`, `timeout` or a server error. The backend must answer a missing or invalid token with `401`, not `403`.
- **Logging**: Never use `print()` or `debugPrint()`. Always use `AppLogger.logInfo`, `AppLogger.logDebug`, `AppLogger.logWarning`, or `AppLogger.logError`.

---

## 7. Documentation & Code Style

- **Doc Comments**: Every class, enum, extension and mixin gets exactly one `///` line. Put the summary and the parameters on that same line, with no blank `///` lines:
  ```dart
  /// A small rounded button with an icon and a label. Params: [icon]: SVG path from [IconPath]. [text]: the already translated label. [onTap]: called when tapped.
  ```
  Barrel files use `/// ...` followed by `library;`.
- **Inside Class Bodies**: Use `//` comments only, never `///`, to explain non-obvious logic or mark sections in widget trees.
- **Formatting & Lints**: Keep `flutter analyze` at **0 warnings and 0 errors** (`package:flutter_lints/flutter.yaml`). Use modern Dart 3 features (switch expressions, records, pattern matching, null-aware elements) where appropriate.

---

## 8. Testing Guidelines

- Mirror the `lib/` directory structure inside `test/` (e.g., `test/core/network/network_caller_test.dart`, `test/features/...`).
- **Architecture & Convention Guard**: `test/core/architecture_test.dart` scans `lib/` to block hardcoded `Color(0x...)` / `Colors.*`, raw `Text(...)` widgets, hardcoded `'assets/...'` strings, `print()` / `debugPrint()` calls, direct `core/network/` imports in views/widgets/controllers, `_buildXxx()` widget methods, sizes hoisted into locals, `fontSize` / `fontWeight` on `CustomText`, feature widgets without the feature prefix, and doc comments that break the one-line `///` rule.
- **Translation Completeness Test**: `test/core/localization/app_translations_test.dart` verifies that `en_US`, `bn_BD`, and `ar_SA` have identical key sets and no empty values.
- **When to Run Tests/Analyze**: **Do NOT run `flutter test` or `flutter analyze` in the terminal after every command** (it slows down iteration). Instead, self-review your code against the checklist below while writing it, and only run `flutter test` / `flutter analyze` when the user explicitly asks or after completing a major milestone.
- **Unit Tests**: Inject fake/mock dependencies (such as a fake `StorageService` or `http.testing` `MockClient`) into `NetworkCaller` or repositories instead of touching platform channels.
- **Widget Tests**: Pump widgets inside `ScreenUtilInit(designSize: const Size(412, 917), ...)` and call `AppSizeClass.init(context)` inside `MaterialApp.builder` so responsive helpers (`getWidth`, `getHeight`, `getSp`, `getRadius`) work identically to production.

---

## 9. Mandatory Self-Review Checklist (For AI Agents)

While writing or editing any code, you **MUST** verify every item below by inspecting your own code (without running slow terminal commands unless requested):
1. [ ] **No Hardcoded Colors/Texts/Assets**: Only `context.appColors`, `CustomText`, and `IconPath` / `IllustrationPath` / `ImagePath` are used.
2. [ ] **No Magic Numbers**: All sizes, paddings, radii, and spacings use `AppDimensions` scaled with `getWidth`, `getHeight`, `getRadius`, or `getSp`.
3. [ ] **All 3 Locales Updated**: Any new key in `AppStrings` has translations in `en_us.dart`, `bn_bd.dart`, and `ar_sa.dart`.
4. [ ] **RTL Ready**: Directional padding/alignment (`EdgeInsetsDirectional`, `AlignmentDirectional`) and RTL icon flipping are used where needed.
5. [ ] **Clean Imports & Disposals**: `hide ContextExtensionss` is used when importing both `get.dart` and `core.dart`; all controllers/timers are disposed in `onClose()`.
6. [ ] **Structure & Docs**: Logic is in the controller, there are no `_buildXxx()` methods, widgets sit in the right folder with the right prefix, and every class has a one-line `///` doc.
