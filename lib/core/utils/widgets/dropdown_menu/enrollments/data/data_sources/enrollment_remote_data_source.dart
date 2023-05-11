import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/models/enrollment_model.dart';
import 'package:logger/logger.dart';

import '../../../../../../errors/exceptions/http/server_exception.dart';
import '../../../../../constants/constants.dart';
import '../../../../../itpsm_utils.dart';
import '../../../../../log/get_logger.dart';

abstract class EnrollmentRemoteDataSource {
  final String studentsEnrollmentsPath = 'enrollments_student';
  /// Calls the http://itpsm-api-host/api/enrollments_student/{studentId} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<EnrollmentModel>> getStudentsEnrollments(int studentId, String token);
}

class EnrollmentRemoteDataSourceImpl extends EnrollmentRemoteDataSource {
  static final Logger logger = getLogger();
  
  final http.Client client;

  EnrollmentRemoteDataSourceImpl({required this.client});
  
  @override
  Future<List<EnrollmentModel>> getStudentsEnrollments(int studentId, String token) async {
    http.Response response = await client.get(
      ItpsmUtils.getApiUri('$studentsEnrollmentsPath/$studentId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
      },
    ).timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

    logger.d('StudentsEnrollments response body: ${response.body}');

    Map<String, dynamic> studentsEnrollmentsResponse = json.decode(response.body);

    if(ItpsmUtils.apiResponseHasErrors(studentsEnrollmentsResponse)) {
      logger.e('StudentsEnrollments error response body: ${json.encode(studentsEnrollmentsResponse)}');
      throw ServerException(title: studentsEnrollmentsResponse['errors']['title'], message: studentsEnrollmentsResponse['errors']['detail']);
    }

    List<EnrollmentModel> enrollments = [];
    Map<String, dynamic> attributes = ItpsmUtils.getAttributesObjectFromApiResponse(studentsEnrollmentsResponse);
    List<Map<String, dynamic>> studentsEnrollments = (attributes['enrollment'] as List).map((e) => e as Map<String, dynamic>).toList();
    
    for (var enrollment in studentsEnrollments) {
      enrollments.add(EnrollmentModel.fromJson(enrollment));
    }

    return enrollments;
  }
}