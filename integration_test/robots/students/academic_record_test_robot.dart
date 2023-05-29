import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/evaluation_tile.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/subjects_evaluations.dart';

import '../test_robot.dart';

class AcademicRecordTestRobot extends TestRobot {
  AcademicRecordTestRobot({required super.tester, required super.find});

  Finder get _enrollmentDropdown {
    return find.byWidgetPredicate((widget) => widget is DropdownButton).first;
  }

  Future<void> selectLastEnrollment() async {
    await tester.tap(_enrollmentDropdown);

    await waitAndSettle();

    final lastItem = find.byWidgetPredicate((widget) => widget is DropdownMenuItem).last;

    await tester.tap(lastItem);

    await waitAndSettle();
  }

  Future<void> expandFirstSubjectsEvauations() async {
    await tester.tap(find.byWidgetPredicate((widget) => widget is ExpandablePanel).first);

    await waitAndSettle();
  }

  Future<void> beginRefreshing() async {
    final evaluationTile = tester.allWidgets.whereType<EvaluationTile>().firstWhere((evaluationTile) {
      return evaluationTile.evaluation.subevaluations != null && evaluationTile.evaluation.subevaluations!.isNotEmpty;
    });

    final button = find.descendant(of: find.byWidget(evaluationTile), matching: find.byType(Expandable)).first;

    await tester.tap(button);

    await waitAndSettle();

    await tester.fling(
      find.byWidgetPredicate((widget) => widget is ExpandablePanel).first, 
      const Offset(0, 400),
      800
    );

    // expect(tester.getSemantics(find.byType(RefreshIndicator)), matchesSemantics(label: 'Refresh'));

    await waitAndSettle();

    await waitFor(const Duration(seconds: 1));
  }

  Future<void> validateScreenInitialization() async {
    expect(_enrollmentDropdown, findsOneWidget);
  }

  Future<void> validateEnrollmentsDropdownMenuIsLoaded() async {
    int? length = tester.firstWidget<DropdownButton>(_enrollmentDropdown).items?.length;

    expectLater(length != null ? length > 0 : false, true);
  }

  Future<void> validateSelectedEnrollmentsEvaluationsAreLoaded() async {
    expectLater(find.byType(SubjectsEvauations), findsAtLeastNWidgets(1));
  }

  Future<void> validateAtLeastOnveEvaluationIsShown() async {
    expect(find.byType(EvaluationTile), findsAtLeastNWidgets(1));
  }
}