import 'package:get/get.dart';
import '../controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Register AppSearchController as a lazy-loaded dependency using GetX
    Get.lazyPut<AppSearchController>(() => AppSearchController());
  }
}
