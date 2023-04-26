import '../failure.dart';

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.title, required super.cause});

  factory ConnectionFailure.defaultConnectionFailure() => const ConnectionFailure(
    title: 'No connection',
    cause: 'The device is not able to establish a stable connection.'
  );
}
