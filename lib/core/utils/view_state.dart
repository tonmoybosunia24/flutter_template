import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:template/core/core.dart';

/// The state a data screen shows: loading, empty, error, offline or content.
enum ViewState { loading, empty, error, offline, content }

/// Gives a data screen's controller its screen state, makes sure only the newest load can change it, and in debug builds follows the dev scenario switcher. Calls [fetchData] on init and again whenever the dev scenario changes.
mixin ViewStateMixin on GetxController {
  // The current state of the screen.
  final Rx<ViewState> state = ViewState.loading.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  int _loadId = 0;
  Worker? _scenarioWorker;

  // Loads the screen data through [runLoad] and shows it with [showResult]. Also used by retry and pull-to-refresh.
  Future<void> fetchData();

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      // Starts over from the loading state when another dev scenario is picked.
      _scenarioWorker = ever(DevScenario.current, (_) {
        state.value = ViewState.loading;
        fetchData();
      });
    }
    fetchData();
  }

  @override
  void onClose() {
    _scenarioWorker?.dispose();
    super.onClose();
  }

  // Runs [request] as the newest load. Returns null when a dev scenario is forced, the controller closed, or a newer load started meanwhile.
  Future<T?> runLoad<T>(Future<T> Function() request) async {
    final loadId = ++_loadId;
    final forced = kDebugMode ? DevScenario.current.value.forcedState : null;
    if (forced != null) {
      isLoading.value = false;
      errorMessage.value = null;
      state.value = forced;
      return null;
    }

    isLoading.value = true;
    final result = await request();
    if (isClosed || loadId != _loadId) return null;
    isLoading.value = false;
    return result;
  }

  // Picks the state after a load. A failed refresh keeps the content on screen and shows a snackbar instead.
  void showResult({
    required bool isSuccess,
    required bool isEmpty,
    String? error,
    bool isOffline = false,
  }) {
    if (isSuccess) {
      errorMessage.value = null;
      state.value = isEmpty ? ViewState.empty : ViewState.content;
    } else if (state.value == ViewState.content) {
      final context = Get.context;
      if (context == null) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: CustomText(
            text: AppStrings.stateRefreshFailed.tr,
            style: context.textTheme.bodyMedium,
          ),
        ),
      );
    } else {
      errorMessage.value = error;
      state.value = isOffline ? ViewState.offline : ViewState.error;
    }
  }
}
