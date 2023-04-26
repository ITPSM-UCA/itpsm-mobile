import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itpsm_mobile/core/utils/constants/constants.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  /// Gets the attributes array from the API [jsonResponse] 
  static List<Map<String, dynamic>> getAttributesArrayFromApiResponse(Map<String, dynamic> jsonResponse) {
    return (jsonResponse['data']['attributes'] as List).map((e) => e as Map<String, dynamic>).toList();
  }

  /// Gets the first object in attributes array from the API [jsonResponse] 
  static Map<String, dynamic> getFirstAttributesArrayFromApiResponse(Map<String, dynamic> jsonResponse) {
    return jsonResponse['data']['attributes'][0];
  }

  /// Gets the errors object from the API [jsonResponse] 
  static Map<String, dynamic> getErrorsObjectFromApiResponse(Map<String, dynamic> jsonResponse) {
    return jsonResponse['errors'];
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

  /// Gets a encoded timeout response body
  static String getTimeoutResponseBody() {
    return json.encode({
      'errors': {
        'status': '408',
        'title': 'Tiempo de respuesta agotada',
        'detail': 'El tiempo de respuesta de la petición ha sido agotado.'
      },
      'jsonapi': {
        'version': '1.00'
      }
    });
  }

  /// Clears all stored data on the [SharedPreferences] object
  static Future<bool> clearSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    return await preferences.clear();
  }

  /// Creates a new Uri instace with the given [path] and given [queryParameters]
  static Uri getApiUri(String path, [Map<String, dynamic>? queryParameters]) {
    // return Uri(path: '$localApiPath/$path', queryParameters: queryParameters ?? {});
    return Uri.parse('$localApiPath/$path').replace(queryParameters: queryParameters);
  }

  /// Returns the bearer token authorization format with the given [token]
  static String getBearerTokenFormat(String token) {
    return 'Bearer $token';
  }

  /// Shows an AlertDialog with the [content] as the dialog content and the [icon] as the dialog title
  static void showAlertDialog(String content, Icon icon, BuildContext context, [String title = '']) {
    showDialog(context: context, builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          elevation: 6,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          title: icon,
          // title: RichText(
          //   text: TextSpan(
          //     children: [
          //       const WidgetSpan(child: Icon(Icons.error)),
          //       TextSpan(text: error.title)
          //     ]
          //   )),
          actionsAlignment: MainAxisAlignment.center,
          content: Text(content, textAlign: TextAlign.center),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar')
            )
          ],
        ),
      ), 
    ));
  }
}