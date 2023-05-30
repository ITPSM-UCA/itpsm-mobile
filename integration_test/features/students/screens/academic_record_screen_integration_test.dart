import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ignore: library_prefixes
import 'package:itpsm_mobile/main.dart' as itpsmMobile;

import '../../../robots/students/academic_record_test_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      return null;
    });
  });

  AcademicRecordTestRobot turnOnAcademicRecordTestRobot(WidgetTester tester, CommonFinders find) {
    return AcademicRecordTestRobot(tester: tester, find: find);
  }

  group('AcademicRecordScreen integration tests', () {
    testWidgets('AcademicRecordScreen initialized', (tester) async {
      itpsmMobile.main();

      final academicRobot = turnOnAcademicRecordTestRobot(tester, find);

      await academicRobot.loginRobot.login();

      await academicRobot.gradesRobot.validateScreenInitialization();

      await academicRobot.selectAcademicRecordScreenOnDrawer();

      await academicRobot.waitAndSettle();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.logout();
    });

    testWidgets('Show approved subjects for at least one year', (tester) async {
      itpsmMobile.main();

      final academicRobot = turnOnAcademicRecordTestRobot(tester, find);

      await academicRobot.loginRobot.login();

      await academicRobot.gradesRobot.validateScreenInitialization();

      await academicRobot.selectAcademicRecordScreenOnDrawer();

      await academicRobot.waitAndSettle();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateApprovedSubjectsAreLoaded();

      await academicRobot.logout();
    });

    testWidgets('Show at least one approved subject', (tester) async {
      itpsmMobile.main();

      final academicRobot = turnOnAcademicRecordTestRobot(tester, find);

      await academicRobot.loginRobot.login();

      await academicRobot.gradesRobot.validateScreenInitialization();

      await academicRobot.selectAcademicRecordScreenOnDrawer();

      await academicRobot.waitAndSettle();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateApprovedSubjectsAreLoaded();

      await academicRobot.expandFirstApprovedSubjectsByYear();

      await academicRobot.validateAtLeastOneApprovedSubjectIsShown();

      await academicRobot.logout();
    });

    testWidgets('Refresh screen', (tester) async {
      itpsmMobile.main();

      final handle = tester.ensureSemantics();
      final academicRobot = turnOnAcademicRecordTestRobot(tester, find);

      await academicRobot.loginRobot.login();

      await academicRobot.gradesRobot.validateScreenInitialization();

      await academicRobot.selectAcademicRecordScreenOnDrawer();

      await academicRobot.waitAndSettle();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateApprovedSubjectsAreLoaded();

      await academicRobot.expandFirstApprovedSubjectsByYear();

      await academicRobot.validateAtLeastOneApprovedSubjectIsShown();

      await academicRobot.beginRefreshing();

      await academicRobot.validateApprovedSubjectsAreLoaded();

      await academicRobot.logout();
      
      handle.dispose();
    });
  });
}