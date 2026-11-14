import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:template/routes/app_routes.dart';

/// Manages the login screen state: form fields and their validation, password visibility, the remember-me option and signing in.
class LoginController extends GetxController {
  // Identifies the login form, so all fields can be validated together on sign in.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingControllers for the email and password input fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive variables to manage the state of password visibility and the remember-me option.
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = false.obs;

  // Errors stay hidden until the first sign-in attempt, then update as the user types.
  final Rx<AutovalidateMode> autovalidateMode = AutovalidateMode.disabled.obs;

  // Toggles the visibility of the password field.
  void togglePasswordVisibility() => isPasswordHidden.toggle();

  // Toggles the remember-me option.
  void toggleRememberMe() => rememberMe.toggle();

  // Only pops when there's a previous route (login is usually opened with offAllNamed).
  void goBack() {
    if (Get.key.currentState?.canPop() ?? false) Get.back();
  }

  // Validates the form and opens the main screen when every field is valid. Replace the navigation with the login API call once a backend is connected.
  void signIn() {
    autovalidateMode.value = AutovalidateMode.onUserInteraction;
    if (!(formKey.currentState?.validate() ?? false)) return;
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
