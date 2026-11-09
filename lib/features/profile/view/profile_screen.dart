import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/profile/controller/profile_controller.dart';
import 'package:template/features/profile/widgets/profile_menu_tile.dart';
import 'package:template/features/profile/widgets/profile_section.dart';
import 'package:template/features/profile/widgets/profile_switch.dart';
import 'package:template/routes/app_routes.dart';

/// The profile tab of the main screen: avatar and name, then the account, preferences, payment and support sections, and a logout button.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: getHeight(AppDimensions.space30)),
                Center(
                  child: Container(
                    width: getRadius(AppDimensions.avatarSizeLarge),
                    height: getRadius(AppDimensions.avatarSizeLarge),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary,
                        width: AppDimensions.borderWidth15,
                      ),
                      image: const DecorationImage(
                        image: AssetImage(ImagePath.profileAvatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(AppDimensions.padding14)),
                CustomText(
                  text: controller.userName,
                  style: context.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getHeight(AppDimensions.space32)),
                ProfileSection(
                  title: AppStrings.profileAccountSettings.tr,
                  children: [
                    ProfileMenuTile(
                      icon: IconPath.account,
                      title: AppStrings.profileMyAccount.tr,
                    ),
                    ProfileMenuTile(
                      icon: IconPath.lockOpen,
                      title: AppStrings.profileChangePassword.tr,
                    ),
                    ProfileMenuTile(
                      icon: IconPath.notification,
                      title: AppStrings.profileNotification.tr,
                      onTap: controller.toggleNotification,
                      trailing: Obx(
                        () => ProfileSwitch(
                          value: controller.notificationEnabled.value,
                          onChanged: controller.toggleNotification,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getHeight(AppDimensions.space20)),
                ProfileSection(
                  title: AppStrings.profilePreferences.tr,
                  children: [
                    Obx(
                      () => ProfileMenuTile(
                        icon: controller.themeIcon,
                        title: AppStrings.profileTheme.tr,
                        onTap: controller.toggleTheme,
                        trailing: ProfileSwitch(
                          value: controller.darkModeSwitch.value,
                          onChanged: controller.toggleTheme,
                        ),
                      ),
                    ),
                    ProfileMenuTile(
                      icon: IconPath.global,
                      title: AppStrings.profileLanguage.tr,
                      value: AppStrings.profileCurrentLanguage.tr,
                      onTap: () => Get.toNamed<void>(AppRoutes.language),
                    ),
                  ],
                ),
                SizedBox(height: getHeight(AppDimensions.space20)),
                ProfileSection(
                  title: AppStrings.profilePayment.tr,
                  children: [
                    ProfileMenuTile(
                      icon: IconPath.moneyAdd,
                      title: AppStrings.profileUpgradePremium.tr,
                    ),
                  ],
                ),
                SizedBox(height: getHeight(AppDimensions.space20)),
                ProfileSection(
                  title: AppStrings.profileSupport.tr,
                  children: [
                    ProfileMenuTile(
                      icon: IconPath.helpCircle,
                      title: AppStrings.profileHelpCenter.tr,
                    ),
                    ProfileMenuTile(
                      icon: IconPath.contracts,
                      title: AppStrings.profileTerms.tr,
                    ),
                    ProfileMenuTile(
                      icon: IconPath.info,
                      title: AppStrings.profilePrivacy.tr,
                    ),
                  ],
                ),
                SizedBox(height: getHeight(AppDimensions.space24)),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      getRadius(AppDimensions.radius100),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.primaryShadow,
                        offset: Offset(0, 4),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: CustomButton(
                    text: AppStrings.profileLogout.tr,
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: getHeight(AppDimensions.space24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
