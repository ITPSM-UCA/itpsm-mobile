import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_robot.dart';

class LoginTestRobot extends TestRobot {
  static const String _psswdObligatoryErrorLabel = 'El ingreso de la contraseña es obligatorio.';
  static const String _emailNotValidErrorLabel = 'Por favor ingrese un correo electrónico válido.';
  static const String _emailObligatoryErrorLabel = 'El ingreso del correo electrónico es obligatorio.';
  
  static const String wrongEmailOrPassowrdErrorLabel = 'Su correo electrónico y/o contraseña es incorrecto.';
  static const String noConnectionErrorLabel = 'The device is not able to establish a stable connection.';
  static const String requestExpiredErrorLabel = 'El tiempo de respuesta de la petición ha sido agotado.';

  LoginTestRobot({required super.tester, required super.find});

  Finder get _emailField {
    return find.byWidgetPredicate((widget) => widget is TextFormField).first;
  }

  Finder get _psswdField {
    return find.byWidgetPredicate((widget) => widget is TextFormField).last;
  }

  /// Taps on the login submit button
  Future<void> tapSubmitButton() async {
    await tester.tap(find.byType(FilledButton));
  }

  /// Taps on the login submit button
  Future<void> tapMakePasswordVisibleButton() async {
    await tester.tap(find.byType(IconButton));
  }
  
  /// Types the [text] into the login email field
  Future<void> typeIntoEmailField(String text) async {
    await tester.enterText(_emailField, text);
  }

  /// Types the [text] into the login password field
  Future<void> typeIntoPasswordField(String text) async {
    await tester.enterText(_psswdField, text);
  }

  /// Validates the login form shows the email and password obligatory error labels
  Future<void> validateObligatoryErrorLabels() async {
    expect(_findErrorLabel(_emailObligatoryErrorLabel), findsOneWidget);
    expect(_findErrorLabel(_psswdObligatoryErrorLabel), findsOneWidget);
  }

  /// Validates the login form shows the email not valid error label
  Future<void> validateNotValidEmailErrorLabel() async {
    expect(_findErrorLabel(_emailNotValidErrorLabel), findsOneWidget);
  }

  /// Validates the login password field text is invisible
  Future<void> validatePasswordFieldStatus({bool isTextObscured = true}) async {
    // Find descendant of an element
    final txtField = find.descendant(of: _psswdField, matching: find.byType(TextField));
    
    // Get the first widget matching the [Finder] passed
    expect(tester.firstWidget<TextField>(txtField).obscureText, isTextObscured);
  }

  /// Validates the login shows an AlertDialog when error
  Future<void> validateAlertErrorDescription(String description) async {
    expectLater(alertDescription, description);
  }

  /// Finds the obligatory error label for the login email or password field 
  Finder _findErrorLabel(String textLabel) {
    // Expect at least one widget with the following text
    return find.text(textLabel);
  }
}