import 'package:flutter/material.dart';
import 'package:template/core/utils/app_dimensions.dart';
import 'package:template/core/utils/extensions.dart';
import 'package:template/core/utils/app_size_class.dart';

/// A reusable text field widget that supports password input, validation, and custom styling. [controller] manages the text input, [hintText] is the placeholder text, [isPassword] indicates if the field should obscure text, [keyboardType] specifies the type of keyboard to display, [validator] allows for custom validation logic, and [prefixIcon] and [suffixIcon] allow for optional icons inside the text field.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: getSp(AppDimensions.font14),
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: colors.textHint,
          fontSize: getSp(AppDimensions.font14),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: getWidth(AppDimensions.padding20),
          vertical: getHeight(AppDimensions.padding16),
        ),
      ),
    );
  }
}
