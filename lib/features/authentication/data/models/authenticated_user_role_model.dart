import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/authenticated_user_role.dart';

part 'authenticated_user_role_model.g.dart';

@JsonSerializable()
class AuthenticatedUserRoleModel extends AuthenticatedUserRole {
  const AuthenticatedUserRoleModel({required super.id, required super.name});

  factory AuthenticatedUserRoleModel.fromJson(Map<String, dynamic> json) => _$AuthenticatedUserRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatedUserRoleModelToJson(this);

  @override
  String toString() {
    return '''AuthenticatedUserPlatformMenuModel(
      id: $id
      name: $name
    )''';
  }
}