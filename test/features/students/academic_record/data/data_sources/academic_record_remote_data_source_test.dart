import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';
import 'academic_record_remote_data_source_test.mocks.dart' as mock;

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  mock.MockClient mockClient = mock.MockClient();
  String curriculaExpectedJson = readFixture('academic_record', 'student_curricula_response.json');
  String subjectsExpectedJson = readFixture('academic_record', 'getacademichistory_response.json');
  String curriculaExpectedErrorJson = readFixture('academic_record', 'student_curricula_error_response.json');
  String subjectsExpectedErrorJson = readFixture('academic_record', 'getacademichistory_error_response.json');
  AcademicRecordRemoteDataSource remoteDataSource = AcademicRecordRemoteDataSourceImpl(client: mockClient);
  Uri studentsCurriculaPath = ItpsmUtils.getApiUri('${remoteDataSource.studentsCurriculaPath}/$studentId');
  Uri studentsApprovedSubjectsPath = ItpsmUtils.getApiUri('${remoteDataSource.studentsApprovedSubjectsPath}/$studentId');
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
  };

  void setUpMockHttpClientResponse(Uri url, Map<String, String> headers, int httpCode, String json) {
    when(mockClient.get(url, headers: headers)).thenAnswer((_) async => http.Response(json, httpCode));
  }

  /* STUDENT'S CURRICULA TESTS */
  group('getStudentsCurricula', () {
    test('Should perform a GET request at ${remoteDataSource.studentsCurriculaPath}', () async {
      setUpMockHttpClientResponse(studentsCurriculaPath, headers, 200, curriculaExpectedJson);

      await remoteDataSource.getStudentsCurricula(studentId, token);

      verify(mockClient.get(studentsCurriculaPath, headers: headers));
    });

    test('Should return a StudentsCurriculaModel when the response code is 200', () async {
      setUpMockHttpClientResponse(studentsCurriculaPath, headers, 200, curriculaExpectedJson);

      final response = await remoteDataSource.getStudentsCurricula(studentId, token);
      
      expect(response, dummyStdCurriculaModel);
    });

    test('Should throw ServerException when the response code is different from 200', () async {
      setUpMockHttpClientResponse(studentsCurriculaPath, headers, 401, curriculaExpectedErrorJson);

      final call = remoteDataSource.getStudentsCurricula;
      
      expect(() => call(studentId, token), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  /* STUDENT'S APPROVED SUBJECTS TESTS */
  group('getStudentsApprovedSubjects', () {
    test('Should perform a GET request at ${remoteDataSource.studentsApprovedSubjectsPath}', () async {
      setUpMockHttpClientResponse(studentsApprovedSubjectsPath, headers, 200, subjectsExpectedJson);

      await remoteDataSource.getStudentsApprovedSubjects(studentId, token);

      verify(mockClient.get(studentsApprovedSubjectsPath, headers: headers));
    });

    test('Should return a List<StudentsApprovedSubjectsModel> when the response code is 200', () async {
      setUpMockHttpClientResponse(studentsApprovedSubjectsPath, headers, 200, subjectsExpectedJson);

      final response = await remoteDataSource.getStudentsApprovedSubjects(studentId, token);
      
      expect(response, dummyStdApdSubModel);
    });

    test('Should throw ServerException when the response code is different from 200', () async {
      setUpMockHttpClientResponse(studentsApprovedSubjectsPath, headers, 200, subjectsExpectedErrorJson);

      final call = remoteDataSource.getStudentsApprovedSubjects;
      
      expect(() => call(studentId, token), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}