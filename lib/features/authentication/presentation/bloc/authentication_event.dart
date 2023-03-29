import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationChangedEvent extends AuthenticationEvent {
  final AuthenticatedUserModel? authenticatedUser;

  const AuthenticationChangedEvent({this.authenticatedUser});

  @override
  List<Object?> get props => [authenticatedUser];
}

class LogoutRequestedEvent extends AuthenticationEvent {}