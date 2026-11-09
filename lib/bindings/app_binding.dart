import 'package:get/get.dart';
import 'package:template/core/network/network_caller.dart';

/// Registers the app-wide dependencies that must exist before the first screen opens, such as [NetworkCaller].
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register global services and controllers as singletons when the app starts
    Get.put<NetworkCaller>(NetworkCaller(), permanent: true);
  }
}