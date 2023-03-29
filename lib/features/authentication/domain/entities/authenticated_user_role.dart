import 'package:equatable/equatable.dart';

abstract class AuthenticatedUserRole extends Equatable {
  final int id;
  final String name;

  const AuthenticatedUserRole({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}