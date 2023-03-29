import 'package:dartz/dartz.dart';

extension EitherAs<L, R> on Either<L, R> {
  R? asRight() => fold((_) => null, (right) => right);
  L? asLeft() => fold((left) => left, (_) => null);
}