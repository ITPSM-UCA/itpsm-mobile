import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:logger/logger.dart';

class ItpsmUtils {
  static final Logger logger = getLogger();

  /// Gets the data object from the API [jsonResponse] 
  static Map<String, dynamic> getDataObjectFromApiResponse(Map<String, dynamic> jsonResponse) {
    return jsonResponse['data'];
  }
  
  /// Gets the attributes object from the API [jsonResponse] 
  static Map<String, dynamic> getAttributesObjectFromApiResponse(Map<String, dynamic> jsonResponse) {
    return jsonResponse['data']['attributes'];
  }

  /// Gets the errors object from the API [jsonResponse] 
  static Map<String, dynamic> getErrorsObjectFromApiResponse(Map<String, dynamic> jsonResponse) {
    return jsonResponse['data']['attributes'];
  }

  /// Checks if the errors object is contained inside the the API [jsonResponse] 
  static bool apiResponseHasErrors(Map<String, dynamic> jsonResponse) {
    return jsonResponse.containsKey('errors');
  }

  /// Parses the API [authenticationResponse] into a valid [AuthenticatedUserModel] JSON map
  static Map<String, dynamic> parseAuthenticationApiResponse(Map<String, dynamic> authenticationResponse) {
    Map<String, dynamic> data = getDataObjectFromApiResponse(authenticationResponse);
    Map<String, dynamic> user = getAttributesObjectFromApiResponse(authenticationResponse);

    user.addAll({'token': data['token']});
    user.addAll({'expires_at': data['expires_at']});
    user.addAll({'token_type' : data['token_type']});
    user.addAll({'platform_menus' : data['platform_menus']});
    return user;
  }
}