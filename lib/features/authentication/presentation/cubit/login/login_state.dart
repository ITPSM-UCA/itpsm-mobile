// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';

import '../../../../../core/errors/failures/http/server_failure.dart';

enum LoginStatus {
  initial,
  submitting,
  success,
  failure
}

class LoginState extends Equatable {
  final LoginStatus status;
  final Failure failure;
  final AuthenticatedUserModel? authenticatedUser;

  const LoginState({
    required this.status,
    required this.failure,
    this.authenticatedUser
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      failure: ServerFailure(),
      authenticatedUser: null
    );
  }

  LoginState copyWith({
    LoginStatus? status,
    Failure? failure,
    AuthenticatedUserModel? authenticatedUser
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      authenticatedUser: authenticatedUser ?? this.authenticatedUser
    );
  }

  @override
  List<Object?> get props => [status, failure, authenticatedUser];
}
