import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_curricula_model.dart';
import 'package:logger/logger.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/itpsm_utils.dart';
import '../../../../../core/utils/log/get_logger.dart';

abstract class AcademicRecordRemoteDataSource {
  final String studentsCurriculaPath = 'student/student-curricula';
  final String studentsApprovedSubjectsPath = 'getacademichistory';

  /// Calls the http://itpsm-api-host/api/student-curricula/{studentId} endpoint and gets the student's curricula.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<StudentsCurriculaModel> getStudentsCurricula(int studentId, String token);

  /// Calls the http://itpsm-api-host/api/enrollment/approved-subjects/{studentId} endpoint and gets the student's approved subjects.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<StudentsApprovedSubjectsModel>> getStudentsApprovedSubjects(int studentId, String token);
}

class AcademicRecordDataSourceImpl extends AcademicRecordRemoteDataSource {
  static final Logger logger = getLogger();
  
  final http.Client client;

  AcademicRecordDataSourceImpl({required this.client});
  
  @override
  Future<StudentsCurriculaModel> getStudentsCurricula(int studentId, String token) async {
    http.Response response = await client.get(
      ItpsmUtils.getApiUri('$studentsCurriculaPath/$studentId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
      },
    ).timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

    logger.d('StudentCurricula response body: ${response.body}');

    Map<String, dynamic> studentCurriculaResponse = json.decode(response.body);

    if(ItpsmUtils.apiResponseHasErrors(studentCurriculaResponse)) {
      logger.e('StudentsCurricula error response body: ${json.encode(studentCurriculaResponse)}');
      throw ServerException(title: studentCurriculaResponse['errors']['title'], message: studentCurriculaResponse['errors']['detail']);
    }

    Map<String, dynamic> studentsCurricula = ItpsmUtils.getFirstAttributesArrayFromApiResponse(studentCurriculaResponse);

    return StudentsCurriculaModel.fromJson(studentsCurricula);
  }
  
  @override
  Future<List<StudentsApprovedSubjectsModel>> getStudentsApprovedSubjects(int studentId, String token) async {
    http.Response response = await client.get(
      ItpsmUtils.getApiUri('$studentsApprovedSubjectsPath/$studentId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
      },
    ).timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

    logger.d('StudentsApprovedSubjects response body: ${response.body}');

    Map<String, dynamic> studentsApprovedSubjectsResponse = json.decode(response.body);

    if(ItpsmUtils.apiResponseHasErrors(studentsApprovedSubjectsResponse)) {
      logger.e('StudentsCurricula error response body: ${json.encode(studentsApprovedSubjectsResponse)}');
      throw ServerException(title: studentsApprovedSubjectsResponse['errors']['title'], message: studentsApprovedSubjectsResponse['errors']['detail']);
    }

    List<StudentsApprovedSubjectsModel> subjects = [];
    List<Map<String, dynamic>> studentsApprovedSubjects = ItpsmUtils.getAttributesArrayFromApiResponse(studentsApprovedSubjectsResponse);

    for (var subject in studentsApprovedSubjects) {
      subjects.add(StudentsApprovedSubjectsModel.fromJson(subject));
    }

    return subjects;
  }
}