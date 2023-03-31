import 'package:equatable/equatable.dart';

abstract class AuthenticatedUserPlatformMenu extends Equatable {
  final int id;
  final String name;
  final String redirectTo;
  final String icon;

  const AuthenticatedUserPlatformMenu({required this.id, required this.name, required this.redirectTo, required this.icon});
  
  @override
  List<Object?> get props => [id, name];
}