// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/features/authentication/domain/entities/authenticated_user.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticatedUser? authenticatedUser;

  const AuthenticationState({required this.status, this.authenticatedUser});

  @override
  List<Object?> get props => [status, authenticatedUser];

  factory AuthenticationState.unknown() {
    return const AuthenticationState(status: AuthenticationStatus.unknown);
  }

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    AuthenticatedUser? authenticatedUser,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      authenticatedUser: authenticatedUser ?? this.authenticatedUser,
    );
  }
}
