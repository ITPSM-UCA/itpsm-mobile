import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestRobot {
  static const Duration pumpDuration = Duration(milliseconds: 500); 

  final WidgetTester tester;
  final CommonFinders find;

  const TestRobot({required this.tester, required this.find});

  Future<void> waitAndSettle() async {
    await tester.pumpAndSettle();
  }

  Future<void> wait() async {
    await tester.pump(pumpDuration);
  }

  String? get alertDescription {
    return tester.firstWidget<Text>(find.descendant(of: find.byType(AlertDialog), matching: find.byType(Text)).first).data;
  }
}