import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';
import 'package:template/features/search/controller/search_controller.dart';

/// The search tab of the main screen. Shows placeholder content until the real design is added.
class SearchScreen extends GetView<AppSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: AppStrings.navSearch.tr,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}
