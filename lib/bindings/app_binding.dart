import 'package:get/get.dart';
import 'package:template/core/network/network_caller.dart';
// import '../core/network/network_caller.dart';

/// This class is responsible for managing the dependencies of the application. It extends [Bindings] from the GetX package, allowing for easy dependency injection and management.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register global services and controllers as singletons when the app starts
    Get.put<NetworkCaller>(NetworkCaller(), permanent: true);
  }
}