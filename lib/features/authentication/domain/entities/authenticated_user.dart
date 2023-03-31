// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'authenticated_user_platform_menu.dart';
import 'authenticated_user_role.dart';

abstract class AuthenticatedUser extends Equatable {
  final int id;
  final String name;
  final String email;
  final String token;
  final String tokenType;
  final String expiresAt;
  final int systemReferenceId;
  final List<AuthenticatedUserRole> roles;
  final List<AuthenticatedUserPlatformMenu> platformMenus;

  const AuthenticatedUser({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.token, 
    required this.tokenType,
    required this.expiresAt,
    required this.systemReferenceId,
    required this.roles,
    required this.platformMenus
  });
  
  @override
  List<Object?> get props => [id, name, email];
}
