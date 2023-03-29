import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';

import '../../data/models/authenticated_user_model.dart';
abstract class AuthenticationRepository {
  Future<Either<Failure, AuthenticatedUserModel>> login(String email, String password);
}