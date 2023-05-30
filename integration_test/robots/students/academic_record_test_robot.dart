import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/approved_subject.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/approved_subjects_by_year.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/student_academic_information.dart';

import '../authentication/login_test_robot.dart';
import '../test_robot.dart';
import 'grades_consultation_test_robot.dart';

class AcademicRecordTestRobot extends TestRobot {
  late final LoginTestRobot loginRobot;
  late final GradesConsultationTestRobot gradesRobot;
  static const String _academicRecordDrawerLabel = 'Historial academico';

  AcademicRecordTestRobot({
    required super.tester,
    required super.find,
  }) {
    loginRobot = LoginTestRobot(tester: tester, find: find);
    gradesRobot = GradesConsultationTestRobot(tester: tester, find: find);
  }

  Future<void> selectAcademicRecordScreenOnDrawer() async {
    await openDrawer();

    final listTile = tester.allWidgets.whereType<ListTile>().firstWhere((listTile) {
      return (listTile.title as Text) == tester.firstWidget<Text>(find.text(_academicRecordDrawerLabel));
    });

    await tester.tap(find.byWidget(listTile));
  }

  Future<void> expandFirstApprovedSubjectsByYear() async {
    await tester.tap(find.byWidgetPredicate((widget) => widget is ExpandablePanel).first);

    await waitAndSettle();
  }

  Future<void> beginRefreshing() async {
    await tester.fling(
      find.byType(StudentAcademicInformation).first, 
      const Offset(0, 400),
      800
    );
    
    await waitAndSettle();

    await waitFor(const Duration(seconds: 1));
  }

  Future<void> validateScreenInitialization() async {
    expect(find.byType(StudentAcademicInformation), findsOneWidget);
  }

  Future<void> validateApprovedSubjectsAreLoaded() async {
    expectLater(find.byType(ApprovedSubjectsByYear), findsAtLeastNWidgets(1));
  }

  Future<void> validateAtLeastOneApprovedSubjectIsShown() async {
    expect(find.byType(ApprovedSubject), findsAtLeastNWidgets(1));
  }
}