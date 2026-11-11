import 'package:get/get.dart';
import 'package:template/features/home/repository/home_repository.dart';

import '../controller/home_controller.dart';

/// Registers [HomeRepository] and [HomeController] for the home tab.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register the repository and controller as lazy-loaded dependencies using GetX
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
