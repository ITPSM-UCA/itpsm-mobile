import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import 'grades_consultation_local_data_source_test.mocks.dart';

List<Map<String, dynamic>> encodeEnrollments() {
  final List<Map<String, dynamic>> json = [];

  for (var enrollment in dummyStdEmts) {
    json.add(enrollment.toJson());
  }

  return json;
}

List<Map<String, dynamic>> encodeEvaluations() {
  final List<Map<String, dynamic>> json = [];

  for (var evaluation in dummyStdEvsModel) {
    json.add(evaluation.toJson());
  }

  return json;
}

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late GradesConsultationLocalDataSource localDataSource;
  String enrollmentsExpectedJson = json.encode(encodeEnrollments());
  String evaluationsExpectedJson = json.encode(encodeEvaluations());

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = GradesConsultationLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  /* STUDENT'S ENROLLMENTS TESTS */
  group('StudentsCurricula local storage', () {
    test('Shoudl call SharedPreferences to cache the List<EnrollmentModel>', () async {
      when(mockSharedPreferences.setString(studentsEnrollmentsKey, enrollmentsExpectedJson))
        .thenAnswer((_) => Future.value(true));

      final didCache = await localDataSource.cacheStudentsEnrollments(dummyStdEmts);

      verify(mockSharedPreferences.setString(studentsEnrollmentsKey, enrollmentsExpectedJson));
      expect(didCache, true);
    });

    test('Should return List<EnrollmentModel> from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(studentsEnrollmentsKey)).thenReturn(enrollmentsExpectedJson);

      final result = await localDataSource.getLastStudentsEnrollments();

      verify(mockSharedPreferences.getString(studentsEnrollmentsKey));
      expect(result, dummyStdEmts);
    });

    test('Should throw CacheException when there is not a List<EnrollmentModel> cached', () async {
      when(mockSharedPreferences.getString(studentsEnrollmentsKey)).thenReturn(null);

      final call = localDataSource.getLastStudentsEnrollments;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  /* STUDENT'S EVALUATIONS TESTS */
  group('StudentsApprovedSubjects local storage', () {
    test('Shoudl call SharedPreferences to cache the List<StudentsEvaluations>', () async {
      when(mockSharedPreferences.setString(studentsEvaluationsKey, evaluationsExpectedJson))
        .thenAnswer((_) => Future.value(true));

      final didCache = await localDataSource.cacheStudentsEvaluations(dummyStdEvsModel);

      verify(mockSharedPreferences.setString(studentsEvaluationsKey, evaluationsExpectedJson));
      expect(didCache, true);
    });

    test('Should return List<StudentsEvaluations> from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(studentsEvaluationsKey)).thenReturn(evaluationsExpectedJson);

      final result = await localDataSource.getLastStudentsEvaluations();

      verify(mockSharedPreferences.getString(studentsEvaluationsKey));
      expect(result, dummyStdEvsModel);
    });

    test('Should throw CacheException when there is not a List<StudentsEvaluations> cached', () async {
      when(mockSharedPreferences.getString(studentsEvaluationsKey)).thenReturn(null);

      final call = localDataSource.getLastStudentsEvaluations;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}