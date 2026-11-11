import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/auth/controller/login_controller.dart';
import 'package:template/features/auth/widgets/auth_social_button.dart';

/// The login screen of the auth flow: email & password fields, remember me, sign in, forgot password, social sign-in and a link to sign up.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: LayoutBuilder(
              // Fills the screen so the form can be vertically centered, but scrolls when the keyboard is open.
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Obx(
                      () => Form(
                        key: controller.formKey,
                        autovalidateMode: controller.autovalidateMode.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: getHeight(AppDimensions.space32)),

                            // Back
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: GestureDetector(
                                onTap: controller.goBack,
                                child: Transform.flip(
                                  flipX:
                                      Directionality.of(context) ==
                                      TextDirection.rtl,
                                  child: CustomSvgIcon(
                                    assetName: IconPath.backArrow,
                                    width: getRadius(AppDimensions.icon32),
                                    height: getRadius(AppDimensions.icon32),
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: getHeight(AppDimensions.space32),
                                    ),

                                    // Title
                                    CustomText(
                                      text: AppStrings.loginTitle.tr,
                                      style: textTheme.displayLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space40),
                                    ),

                                    // Email
                                    CustomTextField(
                                      controller: controller.emailController,
                                      hintText: AppStrings.loginEmailHint.tr,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: AppValidators.emailValidator,
                                      prefixIcon: CustomSvgIcon(
                                        assetName: IconPath.mail,
                                        width: getRadius(AppDimensions.icon20),
                                        height: getRadius(AppDimensions.icon20),
                                        color: colors.textHint,
                                      ),
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space20),
                                    ),

                                    // Password
                                    Obx(
                                      () => CustomTextField(
                                        controller:
                                            controller.passwordController,
                                        hintText:
                                            AppStrings.loginPasswordHint.tr,
                                        isPassword:
                                            controller.isPasswordHidden.value,
                                        validator:
                                            AppValidators.passwordValidator,
                                        prefixIcon: CustomSvgIcon(
                                          assetName: IconPath.lock,
                                          width: getRadius(
                                            AppDimensions.icon20,
                                          ),
                                          height: getRadius(
                                            AppDimensions.icon20,
                                          ),
                                          color: colors.textHint,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: controller
                                              .togglePasswordVisibility,
                                          child: CustomSvgIcon(
                                            assetName:
                                                controller
                                                    .isPasswordHidden
                                                    .value
                                                ? IconPath.eyeOff
                                                : IconPath.eye,
                                            width: getRadius(
                                              AppDimensions.icon20,
                                            ),
                                            height: getRadius(
                                              AppDimensions.icon20,
                                            ),
                                            color: colors.textHint,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space20),
                                    ),

                                    // Remember me
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: GestureDetector(
                                        onTap: controller.toggleRememberMe,
                                        behavior: HitTestBehavior.opaque,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(
                                              () => controller.rememberMe.value
                                                  ? CustomSvgIcon(
                                                      assetName: IconPath
                                                          .checkboxChecked,
                                                      width: getRadius(
                                                        AppDimensions.icon16,
                                                      ),
                                                      height: getRadius(
                                                        AppDimensions.icon16,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: getRadius(
                                                        AppDimensions.icon16,
                                                      ),
                                                      height: getRadius(
                                                        AppDimensions.icon16,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              getRadius(
                                                                AppDimensions
                                                                    .radius4,
                                                              ),
                                                            ),
                                                        border: Border.all(
                                                          color: colors.primary,
                                                          width: AppDimensions
                                                              .borderWidth1,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: getWidth(
                                                AppDimensions.space8,
                                              ),
                                            ),
                                            CustomText(
                                              text:
                                                  AppStrings.loginRememberMe.tr,
                                              style: textTheme.bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space20),
                                    ),

                                    // Sign in
                                    CustomButton(
                                      text: AppStrings.loginSignIn.tr,
                                      onPressed: controller.signIn,
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space24),
                                    ),

                                    // Forgot password
                                    Center(
                                      child: GestureDetector(
                                        onTap: () => {},
                                        child: CustomText(
                                          text:
                                              AppStrings.loginForgotPassword.tr,
                                          style: textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space24),
                                    ),

                                    // Or continue with
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(color: colors.border),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getWidth(
                                              AppDimensions.space8,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: AppStrings
                                                .loginOrContinueWith
                                                .tr,
                                            style: textTheme.bodyMedium,
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(color: colors.border),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space24),
                                    ),

                                    // Social sign in
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AuthSocialButton(
                                          icon: IconPath.facebook,
                                          iconSize: AppDimensions.icon30,
                                          onTap: () => {},
                                        ),
                                        SizedBox(
                                          width: getWidth(
                                            AppDimensions.space10,
                                          ),
                                        ),
                                        AuthSocialButton(
                                          icon: IconPath.google,
                                          iconSize: AppDimensions.icon24,
                                          onTap: () => {},
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space24),
                                    ),

                                    // Sign up
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: getWidth(AppDimensions.space4),
                                      children: [
                                        CustomText(
                                          text: AppStrings.loginNoAccount.tr,
                                          style: textTheme.bodyMedium,
                                        ),
                                        GestureDetector(
                                          onTap: () => {},
                                          child: CustomText(
                                            text: AppStrings.loginSignUp.tr,
                                            style: textTheme.titleMedium,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getHeight(AppDimensions.space32),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
