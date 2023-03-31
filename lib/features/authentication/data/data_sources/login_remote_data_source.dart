import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:logger/logger.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/log/get_logger.dart';
import '../models/authenticated_user_model.dart';

abstract class LoginRemoteDataSource {
  final Uri path = Uri.parse('$localApiPath/login');
  
  /// Calls the http://itpsm-api-host/api/login endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<AuthenticatedUserModel> login(String email, String password);
}

class LoginRemoteDataSourceImpl extends LoginRemoteDataSource {
  static final Logger logger = getLogger();
  
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});
  
  @override
  Future<AuthenticatedUserModel> login(String email, String password) async {
    try {
      http.Response response = await client.post(path, body: {'email': email, 'password': password})
        .timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

      logger.d('Login response body: ${response.body}');

      Map<String, dynamic> authenticationResponse = json.decode(response.body);

      if(ItpsmUtils.apiResponseHasErrors(authenticationResponse)) {
        logger.e('Login error response body: ${json.encode(authenticationResponse)}');
        // TODO: Pass the error response to the ServerException class and handle it
        throw ServerException();
      }

      Map<String, dynamic> user = ItpsmUtils.parseAuthenticationApiResponse(authenticationResponse);

      return AuthenticatedUserModel.fromJson(user);
    } on ServerException catch(e) {
      logger.e('Handled error on login.', e);
      rethrow;
    } catch (e) {
      logger.e('Something went wrong when trying to login....', e);
      throw ServerException();
    }
  }
}