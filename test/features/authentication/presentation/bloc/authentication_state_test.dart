import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_state.dart';

import '../../../../core/utils/dummies/models/dummy_models.dart';

void main() {
  group('AuthenticationState tests', () {
    late final AuthenticationState initialState;
    
    setUp(() => initialState = AuthenticationState.unknown());

    test('Should be a valid AuthenticationState initial state.', () {
      expect(initialState.status, AuthenticationStatus.unknown);
    });

    test('Should make a valid copy of an AuthenticationState instance.', () {
      final newState = initialState.copyWith(
        status: AuthenticationStatus.authenticated,
        authenticatedUser: dummyAuthUserModel
      );

      expect(newState, const AuthenticationState(status: AuthenticationStatus.authenticated, authenticatedUser: dummyAuthUserModel));
    });
  });
}