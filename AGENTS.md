# AGENTS.md — Architecture & Coding Rules

Every AI agent working on this repository **must** strictly follow these conventions. The long-form human reference lives in `docs/ARCHITECTURE.md`.

---

## 1. Tech Stack & Core Setup
- **Framework**: Flutter (Material 3), Dart `^3.13.7`
- **State, DI & Routing**: `get` (`GetX`) — routes in `lib/routes/app_routes.dart` & `lib/routes/app_pages.dart`, global DI in `lib/bindings/app_binding.dart`.
- **Storage**: `StorageService` (`lib/core/storage/storage_service.dart`) wraps `GetStorage` (preferences/flags) and `FlutterSecureStorage` (`access_token`, `refresh_token`). All keys live in `StorageKeys`.
- **Networking**: `NetworkCaller` (`lib/core/network/network_caller.dart`) handles auth headers, queued token refresh (`_refreshCompleter`), 401 retry, and returns `ResponseData<T>` / `AppError`. Only a refresh refusal (400/401/403) logs out; network errors, timeouts and 5xx keep the session. No network, or a network that can't reach the server (`http.ClientException`), returns `AppError.noInternet`.
- **Responsive UI**: `flutter_screenutil` (`412 x 917` design size) + `AppSizeClass` (`lib/core/utils/app_size_class.dart`).

---

## 2. Folder Structure & Layering (`View → Controller → Repository → NetworkCaller`)
```text
lib/
├── main.dart, app.dart, bindings/app_binding.dart, routes/{app_routes,app_pages}.dart
├── core/
│   ├── core.dart                  # Barrel export: config, localization, storage, theme, widgets, utils (NOT network)
│   ├── config/env_config.dart     # Environment (dev/staging/prod) & EnvConfig.baseUrl
│   ├── localization/              # app_translations.dart + langs/{en_us,bn_bd,ar_sa}.dart
│   ├── network/                   # api_endpoints.dart, app_error.dart, network_caller.dart, response_data.dart
│   ├── storage/                   # storage_keys.dart, storage_service.dart
│   ├── theme/                     # app_colors.dart (AppColors + AppColorScheme), app_theme.dart
│   ├── utils/                     # app_dimensions, app_icons, app_illustrations, app_images, app_size_class, app_strings, dev_scenario, extensions, logger, settings_util, validators, view_state
│   └── widgets/                   # CustomAppBar, CustomAppBarAction, CustomButton, CustomPillButton, CustomTextField, CustomText, CustomSvgIcon, CustomNetworkImage, CustomRingAvatar, CustomLoader, CustomComingSoon, CustomStateView, CustomScreenState, CustomSkeleton, CustomSkeletonBox, CustomDevScenarioSwitcher
└── features/<feature>/
    ├── binding/<feature>_binding.dart
    ├── controller/<feature>_controller.dart
    ├── model/<feature>_<model>.dart         # Optional: immutable class with const constructor & fromJson
    ├── repository/<feature>_repository.dart # Optional: injects NetworkCaller? networkCaller
    ├── view/<feature>_screen.dart           # GetView<FeatureController>
    └── widgets/<feature>_<widget>.dart      # Optional: feature sub-widgets prefixed with <feature>_
```

### Layer Rules
1. **Imports**: Import `package:template/core/core.dart` everywhere. When importing both `get.dart` and `core.dart`, always write:
   ```dart
   import 'package:get/get.dart' hide ContextExtensionss;
   ```
2. **Network Isolation**: Never import `lib/core/network/*` in views, widgets, or controllers. Only repositories, `app_binding.dart`, and tests may import `core/network/`. Add every endpoint as a getter in `ApiEndpoints` (`lib/core/network/api_endpoints.dart`), built from `baseUrl` (`EnvConfig.baseUrl`).
3. **Repository**: Accept `NetworkCaller? networkCaller` (`: _caller = networkCaller ?? Get.find<NetworkCaller>()`). Map data with `response.mapData<T>(...)` inside `try/catch`, logging errors via `AppLogger.logError` and returning `ResponseData.failure(error: AppError.unknown, statusCode: response.statusCode)`. Pass `isAuthCall: true` on login/register calls. Take every request value as a typed named parameter (no raw `Map` params, no hardcoded data) so any controller can reuse it.
4. **Controller**: Extend `GetxController`. All logic and state live here, including `AnimationController`s (via `GetSingleTickerProviderStateMixin`) and placeholder/static values. Use `.obs` state, check `if (isClosed) return;` after every `await`, and dispose all controllers/timers in `onClose()`. Prefix with `App` if a name collides with Flutter (e.g., `AppSearchController`). Navigate here only as part of logic (e.g., after saving); simple tap navigation belongs in the view: `onPressed: () => Get.offAllNamed(AppRoutes.main)`.
5. **Binding**: Use `Get.lazyPut` (or `Get.put` only when immediate `onReady` execution is needed, like `SplashController`). Register main tab bindings inside `MainBinding.dependencies()` too.
6. **View & Widgets**: Screens extend `GetView<FeatureController>` with a `const` constructor and stay logic-free. A feature can be a whole flow (`auth` holds login, register, …); each screen gets its own controller and binding. No `_buildXxx()` methods: inline the widget or extract a `StatelessWidget` (or `GetView` when tightly coupled). No `StatefulWidget`, except purely visual animation inside a reusable core widget (like `CustomLoader`).
7. **Widget Placement**: Used by one feature → `features/<feature>/widgets/<feature>_<name>.dart` (class `<Feature>Xxx`). Shared by several features → `core/widgets/` (`Custom*`). Shared only by the main tabs → `features/main/widgets/`.
8. **Static vs Dynamic**: Don't put static UI inside a dynamic list with index offsets; use `CustomScrollView` with a `SliverToBoxAdapter` and a `SliverList`.
9. **Data Screens (API / fetch)**: Every screen that loads data to show uses this pattern; follow `features/home/` and `docs/ARCHITECTURE.md` §3.3. Screens that only send data (forms) use `RxBool isSubmitting` + `CustomButton(isLoading:)` instead.
   - **Controller**: `extends GetxController with ViewStateMixin` and overrides `fetchData()`. The mixin calls it on init, so never call it in `onInit` again:
     ```dart
     @override
     Future<void> fetchData() async {
       final response = await runLoad(_repository.getOrders); // pass the function, no ()
       if (response == null) return; // closed, superseded or dev scenario forced
       if (response.isSuccess) orders.assignAll(response.data ?? const []);
       showResult(
         isSuccess: response.isSuccess,
         isEmpty: orders.isEmpty, // false (or item == null) for a single object
         error: response.errorMessage,
         isOffline: response.error?.isNoInternet ?? false,
       );
     }
     ```
     When the controller adds data itself (e.g. after creating an item), set `state.value = ViewState.content;`.
   - **Screen**: `Obx(() => CustomStateView(state: controller.state.value, isRetrying: controller.isLoading.value, errorMessage: controller.errorMessage.value, onRetry: controller.fetchData, loadingChild: ..., emptyTitle: ..., emptyMessage: ..., child: const OrderList()))`. Never build your own loading/empty/error/offline UI.
   - **Content widget**: `features/<feature>/widgets/<feature>_list.dart` with its own `RefreshIndicator(onRefresh: controller.fetchData)` around an `Obx` list (like `HomeFeed`).
   - **Skeleton**: `features/<feature>/widgets/<feature>_skeleton.dart`, copying the item's layout and paddings with `CustomSkeletonBox` (pass raw `AppDimensions` tokens; it scales them itself), like `HomePostSkeleton`.
   - **Strings**: only the screen's own loading label and empty title/message, in all 3 locales. Error/offline texts are shared.
   - **Dev switcher**: `CustomStateView` adds a debug-only ⚙ button (tabs and pushed pages) that forces Live/Loading/Empty/Error/Offline through `DevScenario`. Nothing to wire up; release builds drop it.

---

## 3. Design System & UI Rules
- **Colors**: Never use `Color(0x...)`, `Colors.*`, or raw `AppColors.*` in UI (except shadow constants like `AppColors.cardShadow`, `AppColors.primaryShadow`, `AppColors.bottomNavShadow`, or `AppColors.white` on fixed contrast elements). Always use `final colors = context.appColors;` (`AppColorScheme`). For a new color token, add Light and Dark variants to `AppColors` and wire them into `AppColorScheme` (`light`, `dark`, `copyWith`, `lerp`).
- **Text**: Never use raw `Text(...)`. Always use `CustomText` with `context.textTheme` styles (`displayLarge`, `displayMedium`, `headlineSmall`, `titleLarge`, `titleMedium`, `titleSmall`, `bodyLarge`, `bodyMedium`, `bodySmall`, `labelLarge`, `labelMedium`, `labelSmall`). `CustomText` scales `fontSize` via `getSp` automatically. Never pass `fontSize` or `fontWeight` to `CustomText`; pick a theme style instead. `color:` is allowed, but only from `context.appColors`.
- **Dimensions & Scaling**: Never use magic numbers. Use tokens from `AppDimensions` (add a new constant there if none fits) scaled with `app_size_class.dart` helpers. Write the helper inline at each use; don't hoist sizes into locals in `build` (`colors`/`textTheme` locals are fine):
  - Horizontal / widths: `getWidth(AppDimensions.padding20)`, `getWidth(AppDimensions.space12)`
  - Vertical / heights: `getHeight(AppDimensions.space24)`, `getHeight(AppDimensions.buttonHeight)`
  - Radii / icons / avatars: `getRadius(AppDimensions.radius20)`, `getRadius(AppDimensions.icon24)`
  - Raw `TextStyle` font size: `getSp(AppDimensions.font14)`
  - Constrain screen bodies with `Center -> ConstrainedBox(constraints: BoxConstraints(maxWidth: maxContentWidth))` (or `AppDimensions.feedMaxWidth` for feeds) and `EdgeInsets.symmetric(horizontal: horizontalPadding)`.
  - Breakpoint-specific values: `getValue<T>(mobile: ..., tablet: ..., desktop: ..., tv: ...)`.
- **Assets**: Never hardcode `'assets/...'` strings. Small single-color UI icons → `assets/icons/` + `IconPath` (render via `CustomSvgIcon`, `color: null` for multi-color brand icons). Large multi-color artwork (onboarding, empty/error states) → `assets/illustrations/` + `IllustrationPath` (never tint). Photos → `assets/images/` + `ImagePath`. Use `CustomNetworkImage` for remote images.
- **Core Widgets First**: Reuse `CustomAppBar`, `CustomButton`, `CustomPillButton`, `CustomTextField`, `CustomRingAvatar`, `CustomLoader`, `CustomComingSoon`, `CustomStateView`, `CustomScreenState`, `CustomSkeleton`, and `CustomSkeletonBox` before creating custom widgets.

---

## 4. Localization, RTL & Code Style
- **3 Locales Required**: Add every new string key to `AppStrings` (`lib/core/utils/app_strings.dart`) and translate it in **all 3 files**: `en_us.dart`, `bn_bd.dart`, and `ar_sa.dart`. Read via `.tr` or `.trParams`. Reusable widgets accept already-translated `String` params (unless using a fixed default like `AppStrings.comingSoon.tr`).
- **RTL Support (`ar_SA`)**: Use `EdgeInsetsDirectional`, `AlignmentDirectional`, and flip directional icons (`IconPath.backArrow`, `IconPath.arrowRight`) in RTL (`flipInRtl: true` or `Transform.flip(flipX: Directionality.of(context) == TextDirection.rtl, ...)`).
- **Theme/Locale Switching**: Always use `SettingsUtil.changeTheme(...)` and `SettingsUtil.changeLanguage(...)`.
- **Logging**: Never use `print()` or `debugPrint()`; use `AppLogger`.
- **Doc Comments**: Every class, enum, extension and mixin gets exactly one `///` line: summary and `Params: [name]: description.` on the same line, no blank `///` lines. Barrel files use `/// ...` + `library;`. Inside class bodies use `//` only, never `///`, and only to say *why*: no comment on fields or members whose name and type already say what they are (`_storage`, `isLoggingOut`); keep one when the reason isn't obvious (e.g. why a delay exists).

---

## 5. Testing & Self-Review Checklist
- **Do NOT run `flutter test` or `flutter analyze` after every command** (to keep iteration fast). Run them only when requested or after major milestones (`test/core/architecture_test.dart` and `test/core/localization/app_translations_test.dart` guard these rules).
- **Test Layout**: Mirror `lib/` inside `test/`. Unit tests inject fakes (`http.testing` `MockClient`, fake `StorageService`) into `NetworkCaller`/repositories instead of touching platform channels. Screen-state logic is covered by `test/core/utils/view_state_test.dart`. Widget tests pump inside `ScreenUtilInit(designSize: const Size(412, 917), ...)` and call `AppSizeClass.init(context)` in `MaterialApp.builder`.
- **Lints**: Keep `flutter analyze` at 0 warnings / 0 errors.
- **Self-Review Before Finishing Any Task**:
  1. [ ] Only `context.appColors`, `CustomText`, and `IconPath`/`IllustrationPath`/`ImagePath` are used (zero hardcoded colors, `Text`, or asset strings).
  2. [ ] All sizes/paddings/radii use `AppDimensions` with `getWidth`, `getHeight`, `getRadius`, or `getSp`.
  3. [ ] New `AppStrings` keys are added to `en_us.dart`, `bn_bd.dart`, and `ar_sa.dart`.
  4. [ ] RTL directional widgets/icon flipping, `hide ContextExtensionss`, `if (isClosed) return;`, and `onClose()` disposals are in place.
  5. [ ] Logic is in the controller, no `_buildXxx()` methods, widgets sit in the right folder, and every class has a one-line `///` doc.
  6. [ ] Data screens use `ViewStateMixin` (`fetchData` with `runLoad` + `showResult`) and `CustomStateView`, with a content-shaped skeleton and their own empty texts.
