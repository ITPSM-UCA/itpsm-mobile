import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}