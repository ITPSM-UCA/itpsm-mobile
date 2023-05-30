import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ignore: library_prefixes
import 'package:itpsm_mobile/main.dart' as itpsmMobile;

import '../../../robots/authentication/login_test_robot.dart';
import '../../../robots/students/grades_consultation_test_robot.dart';

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

  LoginTestRobot turnOnLoginRobot(WidgetTester tester, CommonFinders find) {
    return LoginTestRobot(tester: tester, find: find);
  }

  GradesConsultationTestRobot turnOnGradesConsultationTestRobot(WidgetTester tester, CommonFinders find) {
    return GradesConsultationTestRobot(tester: tester, find: find);
  }

  group('GardesConsultationScreen integration tests', () {
    testWidgets('GardesConsultationScreen initialized', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GradesConsultationTestRobot gradesRobot = turnOnGradesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await gradesRobot.validateScreenInitialization();
    });

    testWidgets('Enrollments drowpdown menu is loaded', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GradesConsultationTestRobot gradesRobot = turnOnGradesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await gradesRobot.validateScreenInitialization();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateEnrollmentsDropdownMenuIsLoaded();
    });

    testWidgets('Evaluations from selected enrollment are loaded', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GradesConsultationTestRobot gradesRobot = turnOnGradesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await gradesRobot.validateScreenInitialization();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await gradesRobot.selectLastEnrollment();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();
    });

    testWidgets('Show at least one evaluation', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GradesConsultationTestRobot gradesRobot = turnOnGradesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await gradesRobot.validateScreenInitialization();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await gradesRobot.selectLastEnrollment();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      await gradesRobot.expandFirstSubjectsEvauations();

      await gradesRobot.validateAtLeastOnveEvaluationIsShown();
    });

    testWidgets('Refresh screen', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GradesConsultationTestRobot gradesRobot = turnOnGradesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await gradesRobot.validateScreenInitialization();

      final handle = tester.ensureSemantics();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await gradesRobot.selectLastEnrollment();

      await gradesRobot.waitFor(const Duration(seconds: 1));

      await gradesRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      await gradesRobot.expandFirstSubjectsEvauations();

      await gradesRobot.validateAtLeastOnveEvaluationIsShown();

      await gradesRobot.beginRefreshing();

      await gradesRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      handle.dispose();
    });
  });
}