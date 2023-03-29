import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository repository;

  LoginCubit({required this.repository}) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.submitting));

    final result = await repository.login(email, password);

    if(result.isRight()) {
      emit(state.copyWith(
        status: LoginStatus.success,
        authenticatedUser: result.asRight()
      ));
    }
    else {
      emit(state.copyWith(
        status: LoginStatus.failure,
        authenticatedUser: null,
        failure: result.asLeft()
      ));
    }
  }
}