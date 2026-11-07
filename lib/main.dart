import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:template/app.dart';
import 'package:template/core/core.dart';

// The main function is the entry point of the Flutter application. It initializes necessary services and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage for local storage
  await SystemChrome.setPreferredOrientations([]); // Set preferred device orientations (empty list allows all orientations)
  Get.put<StorageService>(StorageService(), permanent: true); // Register StorageService as a permanent dependency using GetX
  runApp(const MyApp());
}
