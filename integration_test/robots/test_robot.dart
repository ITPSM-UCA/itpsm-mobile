import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestRobot {
  static const Duration pumpDuration = Duration(milliseconds: 500); 

  final WidgetTester tester;
  final CommonFinders find;
  final String _logoutDrawerLabel = 'Cerrar Sesión';

  const TestRobot({required this.tester, required this.find});

  Future<void> openDrawer() async {
    final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));

    scaffoldState.openDrawer();

    await waitAndSettle();
  }

  Future<void> logout() async {
    await openDrawer();

    final listTile = tester.allWidgets.whereType<ListTile>().firstWhere((listTile) {
      return (listTile.title as Text) == tester.firstWidget<Text>(find.text(_logoutDrawerLabel));
    });

    await tester.tap(find.byWidget(listTile));

    await waitAndSettle();
  }

  Future<void> waitAndSettle() async {
    await tester.pumpAndSettle();
  }

  Future<void> wait() async {
    await tester.pump(pumpDuration);
  }

  Future<void> waitFor(Duration duration) async {
    await tester.pump(duration);
  }

  String? get alertDescription {
    return tester.firstWidget<Text>(find.descendant(of: find.byType(AlertDialog), matching: find.byType(Text)).first).data;
  }
}