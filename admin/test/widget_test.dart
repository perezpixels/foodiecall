import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodiecall_admin/main.dart';

void main() {
  testWidgets('Kitchen webapp opens on onboarding welcome', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const FoodiecallAdminApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Foodiecall Kitchen'), findsWidgets);
    expect(find.text('Party jollof, suya, and egusi'), findsWidgets);
    expect(find.text('Continue'), findsOneWidget);
  });
}
