import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';
import 'grades_consultation_remote_data_source_test.mocks.dart' as mock;

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  mock.MockClient mockClient = mock.MockClient();
  String enrollmentsExpectedJson = readFixture('grades_consultation', 'enrollments_student_response.json');
  String evaluationsExpectedJson = readFixture('grades_consultation', 'students_evaluations_response.json');
  String enrollmentsExpectedErrorJson = readFixture('grades_consultation', 'enrollments_student_error_response.json');
  String evaluationsExpectedErrorJson = readFixture('grades_consultation', 'students_evaluations_error_response.json');
  GradesConsultationRemoteDataSource remoteDataSource = GradesConsultationRemoteDataSourceImpl(client: mockClient);
  Uri studentsEnrollmentsPath = ItpsmUtils.getApiUri('${remoteDataSource.studentsEnrollmentsPath}/$studentId');
  Uri studentsEvaluationsPath = ItpsmUtils.getApiUri('${remoteDataSource.studentsEvaluationsPath}/$studentId');
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
  };

  void setUpMockHttpClientResponse(Uri url, Map<String, String> headers, int httpCode, String json) {
    when(mockClient.get(url, headers: headers)).thenAnswer((_) async => http.Response(json, httpCode));
  }

  /* STUDENT'S CURRICULA TESTS */
  group('getStudentsEnrollments', () {
    test('Should perform a GET request at ${remoteDataSource.studentsEnrollmentsPath}', () async {
      setUpMockHttpClientResponse(studentsEnrollmentsPath, headers, 200, enrollmentsExpectedJson);

      await remoteDataSource.getStudentsEnrollments(studentId, token);

      verify(mockClient.get(studentsEnrollmentsPath, headers: headers));
    });

    test('Should return a StudentsCurriculaModel when the response code is 200', () async {
      setUpMockHttpClientResponse(studentsEnrollmentsPath, headers, 200, enrollmentsExpectedJson);

      final response = await remoteDataSource.getStudentsEnrollments(studentId, token);
      
      expect(response, dummyStdEmts);
    });

    test('Should throw ServerException when the response code is different from 200', () async {
      setUpMockHttpClientResponse(studentsEnrollmentsPath, headers, 401, enrollmentsExpectedErrorJson);

      final call = remoteDataSource.getStudentsEnrollments;
      
      expect(() => call(studentId, token), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  /* STUDENT'S APPROVED SUBJECTS TESTS */
  group('getStudentsEvaluations', () {
    test('Should perform a GET request at ${remoteDataSource.studentsEvaluationsPath}', () async {
      setUpMockHttpClientResponse(studentsEvaluationsPath, headers, 200, evaluationsExpectedJson);

      await remoteDataSource.getStudentsEvaluations(studentId, periodId, token);

      verify(mockClient.get(studentsEvaluationsPath, headers: headers));
    });

    test('Should return a List<StudentsApprovedSubjectsModel> when the response code is 200', () async {
      setUpMockHttpClientResponse(studentsEvaluationsPath, headers, 200, evaluationsExpectedJson);

      final response = await remoteDataSource.getStudentsEvaluations(studentId, periodId, token);
      
      expect(response, dummyStdEvsModel);
    });

    test('Should throw ServerException when the response code is different from 200', () async {
      setUpMockHttpClientResponse(studentsEvaluationsPath, headers, 200, evaluationsExpectedErrorJson);

      final call = remoteDataSource.getStudentsEvaluations;
      
      expect(() => call(studentId, periodId, token), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}