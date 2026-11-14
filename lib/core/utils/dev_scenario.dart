import 'package:get/get.dart';
import 'package:template/core/utils/app_icons.dart';
import 'package:template/core/utils/app_strings.dart';
import 'package:template/core/utils/view_state.dart';

/// A screen state that debug builds can force on every controller using [ViewStateMixin], so each state can be checked without changing the backend. Params: [label]: translation key of the name shown in the switcher. [icon]: SVG path from [IconPath] shown beside the name. [forcedState]: the state screens show instead of loading real data, or null to load it.
enum DevScenario {
  live(AppStrings.devScenarioLive, IconPath.global, null),
  loading(AppStrings.devScenarioLoading, IconPath.loading, ViewState.loading),
  empty(AppStrings.devScenarioEmpty, IconPath.inbox, ViewState.empty),
  error(AppStrings.devScenarioError, IconPath.alertCircle, ViewState.error),
  offline(
    AppStrings.devScenarioOffline,
    IconPath.hotspotOffline,
    ViewState.offline,
  );

  const DevScenario(this.label, this.icon, this.forcedState);

  final String label;
  final String icon;
  final ViewState? forcedState;

  // The scenario picked in the switcher. Only the switcher writes it, and release builds never read it.
  static final Rx<DevScenario> current = DevScenario.live.obs;
}
