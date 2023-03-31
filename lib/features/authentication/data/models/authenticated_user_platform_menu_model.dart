import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/authenticated_user_platform_menu.dart';

part 'authenticated_user_platform_menu_model.g.dart';

@JsonSerializable()
class AuthenticatedUserPlatformMenuModel extends AuthenticatedUserPlatformMenu {
  const AuthenticatedUserPlatformMenuModel({required super.id, required super.name, required super.redirectTo, required super.icon});

  factory AuthenticatedUserPlatformMenuModel.fromJson(Map<String, dynamic> json) => _$AuthenticatedUserPlatformMenuModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatedUserPlatformMenuModelToJson(this);

  @override
  String toString() {
    return '''AuthenticatedUserPlatformMenuModel(
      id: $id
      name: $name
      redirectTo: $redirectTo
      icon: $icon
    )''';
  }
}