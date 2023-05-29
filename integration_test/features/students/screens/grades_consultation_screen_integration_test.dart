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

  GardesConsultationTestRobot turnOnGardesConsultationTestRobot(WidgetTester tester, CommonFinders find) {
    return GardesConsultationTestRobot(tester: tester, find: find);
  }

  group('GardesConsultationScreen integration tests', () {
    testWidgets('GardesConsultationScreen initialized', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GardesConsultationTestRobot academicRobot = turnOnGardesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await academicRobot.validateScreenInitialization();
    });

    testWidgets('Enrollments drowpdown menu is loaded', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GardesConsultationTestRobot academicRobot = turnOnGardesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateEnrollmentsDropdownMenuIsLoaded();
    });

    testWidgets('Evaluations from selected enrollment are loaded', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GardesConsultationTestRobot academicRobot = turnOnGardesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await academicRobot.selectLastEnrollment();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();
    });

    testWidgets('Show at least one evaluation', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GardesConsultationTestRobot academicRobot = turnOnGardesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await academicRobot.validateScreenInitialization();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await academicRobot.selectLastEnrollment();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      await academicRobot.expandFirstSubjectsEvauations();

      await academicRobot.validateAtLeastOnveEvaluationIsShown();
    });

    testWidgets('Refresh screen', (tester) async {
      itpsmMobile.main();

      LoginTestRobot loginRobot = turnOnLoginRobot(tester, find);
      GardesConsultationTestRobot academicRobot = turnOnGardesConsultationTestRobot(tester, find);

      await loginRobot.login();

      await academicRobot.validateScreenInitialization();

      final handle = tester.ensureSemantics();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateEnrollmentsDropdownMenuIsLoaded();

      await academicRobot.selectLastEnrollment();

      await academicRobot.waitFor(const Duration(seconds: 1));

      await academicRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      await academicRobot.expandFirstSubjectsEvauations();

      await academicRobot.validateAtLeastOnveEvaluationIsShown();

      await academicRobot.beginRefreshing();

      await academicRobot.validateSelectedEnrollmentsEvaluationsAreLoaded();

      handle.dispose();
    });
  });
}