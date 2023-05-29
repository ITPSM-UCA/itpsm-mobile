import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ignore: library_prefixes
import 'package:itpsm_mobile/main.dart' as itpsmMobile;

import '../../../robots/authentication/login_test_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
  });

  LoginTestRobot turnOnRobot(WidgetTester tester, CommonFinders find) {
    return LoginTestRobot(tester: tester, find: find);
  }

  group('LoginScreen integration test', () {
    testWidgets('Empty LoginScreen', (tester) async {
      // Initialize app
      itpsmMobile.main();

      LoginTestRobot robot = turnOnRobot(tester, find);

      await robot.waitAndSettle();

      // Do a click on button
      await robot.tapSubmitButton();

      // Wait for visual change
      await robot.wait();

      await robot.validateObligatoryErrorLabels();
    });

    testWidgets('Email field is invalid', (tester) async {
      itpsmMobile.main();

      LoginTestRobot robot = turnOnRobot(tester, find);

      await tester.pumpAndSettle();

      // Type into a element
      await robot.typeIntoEmailField('not_an_email');

      await robot.wait();

      await robot.tapSubmitButton();

      await robot.wait();

      await robot.validateNotValidEmailErrorLabel();
    });

    testWidgets('Passowrd field is invisible', (tester) async {
      itpsmMobile.main();

      LoginTestRobot robot = turnOnRobot(tester, find);
      
      await robot.waitAndSettle();

      await robot.typeIntoPasswordField('is_invisible');

      await robot.wait();
      
      await robot.validatePasswordFieldStatus();
    });

    testWidgets('Passowrd field is visible', (tester) async {
      itpsmMobile.main();

      LoginTestRobot robot = turnOnRobot(tester, find);
      
      await robot.waitAndSettle();

      await robot.typeIntoPasswordField('is_invisible');

      await robot.wait();

      await robot.tapMakePasswordVisibleButton();

      await robot.wait();
      
      await robot.validatePasswordFieldStatus(isTextObscured: false);
    });

    testWidgets('Email not found in LoginScreen', (tester) async {
      itpsmMobile.main();
      
      LoginTestRobot robot = turnOnRobot(tester, find);

      await robot.waitAndSettle();

      await robot.typeIntoEmailField('email@itpsm.edu.sv');
      await robot.typeIntoPasswordField('password');

      await robot.wait();

      await robot.tapSubmitButton();

      await robot.waitAndSettle();
      
      await robot.validateAlertErrorDescription(LoginTestRobot.wrongEmailOrPassowrdErrorLabel);
    });

    testWidgets('Password not found in LoginScreen', (tester) async {
      itpsmMobile.main();
      
      LoginTestRobot robot = turnOnRobot(tester, find);

      await robot.waitAndSettle();

      await robot.typeIntoEmailField('mb@itpsm.edu.sv');
      await robot.typeIntoPasswordField('psswd');

      await robot.wait();

      await robot.tapSubmitButton();

      await robot.waitAndSettle();
      
      await robot.validateAlertErrorDescription(LoginTestRobot.wrongEmailOrPassowrdErrorLabel);
    });

    testWidgets('Device has not internet connection.', (tester) async {
      itpsmMobile.main();
      
      LoginTestRobot robot = turnOnRobot(tester, find);

      await robot.waitAndSettle();

      await robot.typeIntoEmailField('mb@itpsm.edu.sv');
      await robot.typeIntoPasswordField('password');

      await robot.wait();

      await robot.tapSubmitButton();

      await robot.waitAndSettle();
      
      await robot.validateAlertErrorDescription(LoginTestRobot.noConnectionErrorLabel);
    });

    testWidgets('HTTP request expired.', (tester) async {
      itpsmMobile.main();
      
      LoginTestRobot robot = turnOnRobot(tester, find);

      await robot.waitAndSettle();

      await robot.typeIntoEmailField('mb@itpsm.edu.sv');
      await robot.typeIntoPasswordField('password');

      await robot.wait();

      await robot.tapSubmitButton();

      await robot.waitAndSettle();
      
      await robot.validateAlertErrorDescription(LoginTestRobot.requestExpiredErrorLabel);
    });
  });
}