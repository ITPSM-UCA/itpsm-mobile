import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/globals/session_timer.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:logger/logger.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final Logger logger = getLogger();
  
  final AuthenticationRepository repository;

  AuthenticationBloc({required this.repository}) : super(AuthenticationState.unknown()) {
    on<AuthenticationChangedEvent>((event, emit) {
      if(event.authenticatedUser != null) {
        logger.d('User authenticated!');

        emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          authenticatedUser: event.authenticatedUser
        ));

        _startAutoLogout(event.authenticatedUser!);
      }
      else {
        logger.d('User authenticaton failed!');

        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          authenticatedUser: null
        ));
      }
    });

    on<LogoutRequestedEvent>((event, emit) async {
      logger.d('Logout requested.');
      logger.d('Clearing shared preferences...');

      await ItpsmUtils.clearSharedPreferences();

      logger.d('Shared preferences cleared.');

      SessionTimer.stopTimer();

      logger.d('Session timer stopped.');

      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        authenticatedUser: null
      ));
    });
  }

  void setAuthentication(AuthenticatedUserModel? authenticatedUser) {
    add(AuthenticationChangedEvent(authenticatedUser: authenticatedUser));
  }

  void _startAutoLogout(AuthenticatedUserModel authenticatedUser) {
    final expireDate = DateTime.now().add(const Duration(minutes: 16));

    SessionTimer.startTimer(expireDate, () { add(LogoutRequestedEvent()); });
  }
}