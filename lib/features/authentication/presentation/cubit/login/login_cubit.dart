import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/constants/constants.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:itpsm_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:logger/logger.dart';

class LoginCubit extends Cubit<LoginState> {
  static final Logger logger = getLogger();

  final AuthenticationRepository repository;

  LoginCubit({required this.repository}) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.submitting));

    logger.d("Sending login request to $apiName");

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