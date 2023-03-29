import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;
  AuthenticationBloc({required this.repository}) : super(AuthenticationState.unknown()) {
    on<AuthenticationChangedEvent>((event, emit) {
      if(event.authenticatedUser != null) {
        emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          authenticatedUser: event.authenticatedUser
        ));
      }
      else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          authenticatedUser: null
        ));
      }
    });
  }

  void setAuthentication(AuthenticatedUserModel? authenticatedUser) {
    add(AuthenticationChangedEvent(authenticatedUser: authenticatedUser));
  }
}