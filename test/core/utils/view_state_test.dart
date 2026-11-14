import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:template/core/utils/dev_scenario.dart';
import 'package:template/core/utils/view_state.dart';

/// What one fake load returns: whether it worked, whether it had no items, its error and whether that error was no internet.
typedef _Result = ({bool ok, bool empty, String? error, bool offline});

const _Result _data = (ok: true, empty: false, error: null, offline: false);
const _Result _empty = (ok: true, empty: true, error: null, offline: false);
const _Result _failed = (
  ok: false,
  empty: false,
  error: 'Server down',
  offline: false,
);
const _Result _noInternet = (
  ok: false,
  empty: false,
  error: 'No internet',
  offline: true,
);

/// A data screen controller whose every load waits until the test answers it, so a test decides what each load returns and in which order.
class _FakeController extends GetxController with ViewStateMixin {
  final List<Completer<_Result>> loads = [];

  @override
  Future<void> fetchData() async {
    final result = await runLoad(() {
      final load = Completer<_Result>();
      loads.add(load);
      return load.future;
    });
    if (result == null) return;

    showResult(
      isSuccess: result.ok,
      isEmpty: result.empty,
      error: result.error,
      isOffline: result.offline,
    );
  }

  // Answers the load at [index] and lets the controller react.
  Future<void> answer(int index, _Result result) async {
    loads[index].complete(result);
    await Future<void>.delayed(Duration.zero);
  }
}

/// Tests how [ViewStateMixin] picks the screen state from each load.
void main() {
  late _FakeController controller;

  setUp(() => controller = Get.put(_FakeController()));

  tearDown(() {
    // Closing first stops the dev scenario worker before the scenario is reset.
    Get.delete<_FakeController>();
    DevScenario.current.value = DevScenario.live;
  });

  test('starts loading on init and shows the content', () async {
    expect(controller.state.value, ViewState.loading);
    expect(controller.isLoading.value, isTrue);
    expect(controller.loads, hasLength(1));

    await controller.answer(0, _data);

    expect(controller.state.value, ViewState.content);
    expect(controller.isLoading.value, isFalse);
  });

  test('a successful load with no items shows the empty state', () async {
    await controller.answer(0, _empty);

    expect(controller.state.value, ViewState.empty);
  });

  test('a first failure shows the error with its message', () async {
    await controller.answer(0, _failed);

    expect(controller.state.value, ViewState.error);
    expect(controller.errorMessage.value, 'Server down');
  });

  test('a first failure without internet shows the offline state', () async {
    await controller.answer(0, _noInternet);

    expect(controller.state.value, ViewState.offline);
  });

  test('a failed refresh keeps the content on screen', () async {
    await controller.answer(0, _data);

    controller.fetchData();
    await controller.answer(1, _failed);

    expect(controller.state.value, ViewState.content);
    expect(controller.errorMessage.value, isNull);
  });

  test('a successful retry after an error shows the content', () async {
    await controller.answer(0, _failed);

    controller.fetchData();
    await controller.answer(1, _data);

    expect(controller.state.value, ViewState.content);
    expect(controller.errorMessage.value, isNull);
  });

  test('a late reply from an older load is ignored', () async {
    controller.fetchData();
    await controller.answer(1, _empty);
    await controller.answer(0, _data);

    expect(controller.state.value, ViewState.empty);
  });

  test('a reply after the controller closed is ignored', () async {
    Get.delete<_FakeController>();
    await controller.answer(0, _data);

    expect(controller.state.value, ViewState.loading);
  });

  test('a forced dev scenario shows its state without loading', () async {
    DevScenario.current.value = DevScenario.empty;
    await Future<void>.delayed(Duration.zero);

    expect(controller.state.value, ViewState.empty);
    expect(controller.loads, hasLength(1));

    // Back to live loads real data again.
    DevScenario.current.value = DevScenario.live;
    await Future<void>.delayed(Duration.zero);
    expect(controller.state.value, ViewState.loading);
    await controller.answer(1, _data);

    expect(controller.state.value, ViewState.content);
  });
}
