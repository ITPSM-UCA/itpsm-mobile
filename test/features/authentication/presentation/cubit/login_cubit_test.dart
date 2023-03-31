import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/dummies/models/dummy_models.dart';
import '../../domain/use_cases/login_user_test.mocks.dart';

void main() {
  late final LoginCubit loginCubit;
  late final MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    loginCubit = LoginCubit(repository: mockRepository);
  });

  group('login', () {
    blocTest<LoginCubit, LoginState>(
      'Should emit [LoginStatus.submitting, LoginStatus.success] when login() is called successfully',
      setUp: () =>
        when(mockRepository.login(studentEmail, adminPassword))
          .thenAnswer((_) async => const Right(dummyAuthUserModel)),
      build: () => loginCubit,
      act: (bloc) => bloc.login(studentEmail, adminPassword),
      expect: () => [
        const LoginState(
          authenticatedUser: null,
          failure: ServerFailure(),
          status: LoginStatus.submitting
        ),
        const LoginState(
          authenticatedUser: dummyAuthUserModel,
          failure: ServerFailure(),
          status: LoginStatus.success
        ),
      ],
      verify: (_) async {
        verify(mockRepository.login(studentEmail, adminPassword));
      },
    );
  });
}