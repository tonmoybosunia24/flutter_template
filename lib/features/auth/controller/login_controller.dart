import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Manages the login screen state: form fields, password visibility and the remember-me option. The action methods are placeholders to be wired to the real auth logic.
class LoginController extends GetxController {
  // TextEditingControllers for the email and password input fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive variables to manage the state of password visibility and the remember-me option.
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = true.obs;

  // Toggles the visibility of the password field.
  void togglePasswordVisibility() => isPasswordHidden.toggle();

  // Toggles the remember-me option.
  void toggleRememberMe() => rememberMe.toggle();

  // Only pops when there's a previous route (login is usually opened with offAllNamed).
  void goBack() {
    if (Get.key.currentState?.canPop() ?? false) Get.back();
  }

  // Placeholder for sign-in functionality.
  void signIn() {}

  // Placeholder for forgot password functionality.
  void forgotPassword() {}

  // Placeholder for social sign-in functionality.
  void signInWithFacebook() {}

  // Placeholder for social sign-in functionality.
  void signInWithGoogle() {}

  // Placeholder for social sign-in functionality.
  void signUp() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
