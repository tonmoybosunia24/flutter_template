import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template/core/core.dart';

/// Pumps [child] with the responsive sizing setup that the core widgets need.
Future<void> _pumpInApp(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(412, 917),
      builder: (context, _) => MaterialApp(
        builder: (context, page) {
          AppSizeClass.init(context);
          return page!;
        },
        home: Scaffold(body: child),
      ),
    ),
  );
}

/// Tests the label, tap and loading behavior of [CustomButton].
void main() {
  testWidgets('shows the label and reports taps', (tester) async {
    var taps = 0;
    await _pumpInApp(tester, CustomButton(text: 'Save', onPressed: () => taps++));

    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    expect(taps, 1);
  });

  testWidgets('shows the optional icon', (tester) async {
    await _pumpInApp(
      tester,
      CustomButton(text: 'Save', icon: Icons.check, onPressed: () {}),
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await _pumpInApp(
      tester,
      CustomButton(text: 'Save', isLoading: true, onPressed: () => taps++),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    expect(taps, 0);
  });
}
