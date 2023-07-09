import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../../../core/errors/exceptions/http/server_exception.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/itpsm_utils.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../models/enrollment_model.dart';
import '../models/students_evaluations_model.dart';

abstract class GradesConsultationRemoteDataSource {
  final String studentsEnrollmentsPath = 'enrollments_student';
  final String studentsEvaluationsPath = 'evaluations/student';

  /// Calls the http://itpsm-api-host/api/enrollments_student/{studentId} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<EnrollmentModel>> getStudentsEnrollments(int studentId, String token);

  /// Calls the http://itpsm-api-host/api/evaluations/student/{studentId} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<StudentsEvaluationsModel>> getStudentsEvaluations(int studentId, int periodId, String token);
}

class GradesConsultationRemoteDataSourceImpl extends GradesConsultationRemoteDataSource {
  static final Logger logger = getLogger();
  
  final http.Client client;

  GradesConsultationRemoteDataSourceImpl({required this.client});

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
  
  @override
  Future<List<StudentsEvaluationsModel>> getStudentsEvaluations(int studentId, int periodId, String token) async {
    http.Response response = await client.get(
      ItpsmUtils.getApiUri('$studentsEvaluationsPath/$studentId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
      },
    ).timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

    logger.d('StudentsEvaluations response body: ${response.body}');

    Map<String, dynamic> studentsEvaluationsResponse = json.decode(response.body);

    if(ItpsmUtils.apiResponseHasErrors(studentsEvaluationsResponse)) {
      logger.e('StudentsEvaluations error response body: ${json.encode(studentsEvaluationsResponse)}');
      throw ServerException(title: studentsEvaluationsResponse['errors']['title'], message: studentsEvaluationsResponse['errors']['detail']);
    }

    List<StudentsEvaluationsModel> evaluations = [];
    List<Map<String, dynamic>> studentsEvaluations = ItpsmUtils.getAttributesArrayFromApiResponse(studentsEvaluationsResponse);
    
    for (var evaluation in studentsEvaluations) {
      evaluations.add(StudentsEvaluationsModel.fromJson(evaluation));
      logger.d('StudentsEvaluations response body: ${StudentsEvaluationsModel.fromJson(evaluation)}');
    }

    return evaluations.where((evaluation) => evaluation.periodId == periodId).toList();
  }
}