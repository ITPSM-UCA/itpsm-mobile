import 'package:equatable/equatable.dart';

abstract class AuthenticatedUserPlatformMenu extends Equatable {
  final int id;
  final String name;

  const AuthenticatedUserPlatformMenu({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}