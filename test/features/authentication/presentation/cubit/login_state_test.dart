import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_state.dart';

import '../../../../core/utils/dummies/models/dummy_models.dart';

void main() {
  group('LoginState tests', () {
    late final LoginState initialState;
    
    setUp(() => initialState = LoginState.initial());

    test('Should be a valid LoginState initial state.', () {
      expect(initialState.status, LoginStatus.initial);
    });

    test('Should make a valid copy of a LoginState instance.', () {
      final newState = initialState.copyWith(
        status: LoginStatus.success,
        failure: const ServerFailure(),
        authenticatedUser: dummyAuthUserModel
      );

      expect(newState, const LoginState(status: LoginStatus.success, failure: ServerFailure(), authenticatedUser: dummyAuthUserModel));
    });
  });
}