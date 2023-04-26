import 'dart:convert';

import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants/constants.dart';
import '../models/authenticated_user_model.dart';

abstract class LoginLocalDataSource {
  /// Gets the cached [AuthenticatedUserModel] which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<AuthenticatedUserModel> getLastLoginSession();
  /// Caches the [AuthenticatedUserModel] obtained through the API.
  Future<bool> cacheLoginSession(AuthenticatedUserModel authUser);
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final SharedPreferences sharedPreferences;

  LoginLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheLoginSession(AuthenticatedUserModel authUser) {
    final authUserToCache = json.encode(authUser.toJson());
    
    return Future.value(sharedPreferences.setString(authenticatedUserKey, authUserToCache));
  }

  @override
  Future<AuthenticatedUserModel> getLastLoginSession() {
    final jsonString = sharedPreferences.getString(authenticatedUserKey);

    if(jsonString != null) {
      return Future.value(AuthenticatedUserModel.fromJson(json.decode('jsonString')));
    }
    else {
      throw CacheException(title: 'No session found', message: 'No previous session was found stored in the device.');
    }
  }

}