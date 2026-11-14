import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// A round floating button, shown only in debug builds, that opens a card of dev scenarios beside it in a three-column grid. Picking one forces that state on every screen using [ViewStateMixin] and closes the card. [CustomStateView] places it above every data screen.
class CustomDevScenarioSwitcher extends StatelessWidget {
  const CustomDevScenarioSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    final colors = context.appColors;

    return PositionedDirectional(
      start: horizontalPadding,
      end: horizontalPadding,
      bottom: getHeight(AppDimensions.space12),
      child: ObxValue<RxBool>((isOpen) {
        final current = DevScenario.current.value;

        // Only the card and the button take taps; the empty space beside them lets them through.
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isOpen.value) ...[
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: getWidth(AppDimensions.floatingCardMaxWidth),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(
                        getRadius(AppDimensions.padding12),
                      ),
                      // Three equal columns, so every button has the same width.
                      child: LayoutBuilder(
                        builder: (_, constraints) => Wrap(
                          spacing: getWidth(AppDimensions.space8),
                          runSpacing: getHeight(AppDimensions.space8),
                          children: [
                            for (final scenario in DevScenario.values)
                              SizedBox(
                                width:
                                    (constraints.maxWidth -
                                        getWidth(AppDimensions.space8) * 2) /
                                    3,
                                child: _DevScenarioButton(
                                  scenario: scenario,
                                  isActive: current == scenario,
                                  onTap: () {
                                    DevScenario.current.value = scenario;
                                    isOpen.value = false;
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: getWidth(AppDimensions.space12)),
            ],
            Semantics(
              button: true,
              label: AppStrings.devScenarioBadge.trParams({
                'name': current.label.tr,
              }),
              child: GestureDetector(
                onTap: isOpen.toggle,
                child: Container(
                  width: getRadius(AppDimensions.appBarActionSize),
                  height: getRadius(AppDimensions.appBarActionSize),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: colors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: CustomSvgIcon(
                    assetName: IconPath.settings,
                    width: getRadius(AppDimensions.icon24),
                    height: getRadius(AppDimensions.icon24),
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        );
      }, false.obs),
    );
  }
}

/// One scenario button in the switcher card, with the scenario's icon before its name: outlined, or filled with the primary gradient when picked. Params: [scenario]: the scenario this button stands for. [isActive]: whether it is the current one. [onTap]: called when the button is tapped.
class _DevScenarioButton extends StatelessWidget {
  final DevScenario scenario;
  final bool isActive;
  final VoidCallback onTap;

  const _DevScenarioButton({
    required this.scenario,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getHeight(AppDimensions.chipHeight),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isActive ? colors.primaryGradient : null,
          border: isActive
              ? null
              : Border.all(
                  color: colors.border,
                  width: AppDimensions.borderWidth1,
                ),
          borderRadius: BorderRadius.circular(
            getRadius(AppDimensions.radius100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: scenario.icon,
              width: getRadius(AppDimensions.icon16),
              height: getRadius(AppDimensions.icon16),
              color: isActive ? colors.onPrimary : colors.primary,
            ),
            SizedBox(width: getWidth(AppDimensions.space6)),
            Flexible(
              child: CustomText(
                text: scenario.label.tr,
                style: context.textTheme.bodySmall,
                color: isActive ? colors.onPrimary : colors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
