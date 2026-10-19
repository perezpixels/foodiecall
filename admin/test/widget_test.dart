import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodiecall_admin/main.dart';

void main() {
  testWidgets('Landing opens with brand and admin CTA', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const FoodiecallAdminApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Foodiecall'), findsWidgets);
    expect(find.text('Get started'), findsWidgets);
    expect(find.text('Download app'), findsWidgets);
  });
}
