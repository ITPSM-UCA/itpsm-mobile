// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/authenticated_user.dart';
import 'authenticated_user_platform_menu_model.dart';
import 'authenticated_user_role_model.dart';

part 'authenticated_user_model.g.dart';

@JsonSerializable()
class AuthenticatedUserModel extends AuthenticatedUser {
  @override
  @JsonKey(name: 'token_type')
  // ignore: overridden_fields
  final String tokenType;
  @override
  @JsonKey(name: 'expires_at')
  // ignore: overridden_fields
  final String expiresAt;
  @override
  // ignore: overridden_fields
  final List<AuthenticatedUserRoleModel> roles;
  @override
  @JsonKey(name: 'platform_menus')
  // ignore: overridden_fields
  final List<AuthenticatedUserPlatformMenuModel> platformMenus;

  const AuthenticatedUserModel({
    required super.id, 
    required super.name, 
    required super.email, 
    required super.token, 
    required this.tokenType,
    required this.expiresAt, 
    required this.roles, 
    required this.platformMenus 
  }) : super(tokenType: tokenType, expiresAt: expiresAt, roles: roles, platformMenus: platformMenus);

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) => _$AuthenticatedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatedUserModelToJson(this);

  AuthenticatedUserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? tokenType,
    String? expiresAt,
    List<AuthenticatedUserRoleModel>? roles,
    List<AuthenticatedUserPlatformMenuModel>? platformMenus,
  }) {
    return AuthenticatedUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      roles: roles ?? this.roles,
      platformMenus: platformMenus ?? this.platformMenus,
    );
  }

  @override
  String toString() {
    return '''AuthenticatedUserModel(
      id: $id
      name: $name 
      email: $email 
      token: $token 
      tokenType: $tokenType, 
      expiresAt: $expiresAt, 
      roles: $roles, 
      platformMenus: $platformMenus
    )''';
  }
}
