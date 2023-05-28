import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../authentication/data/data_sources/login_local_data_source_test.mocks.dart';

List<Map<String, dynamic>> encodeSubjects() {
  final List<Map<String, dynamic>> jsonSubjects = [];

  for (var subject in dummyStdApdSubModel) {
    jsonSubjects.add(subject.toJson());
  }

  return jsonSubjects;
}

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late AcademicRecordLocalDataSource localDataSource;
  String subjectsExpectedJson = json.encode(encodeSubjects());
  String curriculaExpectedJson = json.encode(dummyStdCurriculaModel.toJson());

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = AcademicRecordLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  /* STUDENT'S CURRICULA TESTS */
  group('StudentsCurricula local storage', () {
    test('Shoudl call SharedPreferences to cache the StudentsCurriculaModel', () async {
      when(mockSharedPreferences.setString(studentsCurriculaKey, curriculaExpectedJson))
        .thenAnswer((_) => Future.value(true));

      final didCache = await localDataSource.cacheStudentsCurricula(dummyStdCurriculaModel);

      verify(mockSharedPreferences.setString(studentsCurriculaKey, curriculaExpectedJson));
      expect(didCache, true);
    });

    test('Should return StudentsCurriculaModel from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(studentsCurriculaKey)).thenReturn(curriculaExpectedJson);

      final result = await localDataSource.getLastStudentsCurricula();

      verify(mockSharedPreferences.getString(studentsCurriculaKey));
      expect(result, dummyStdCurriculaModel);
    });

    test('Should throw CacheException when there is not a StudentsCurriculaModel cached', () async {
      when(mockSharedPreferences.getString(studentsCurriculaKey)).thenReturn(null);

      final call = localDataSource.getLastStudentsCurricula;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  /* STUDENT'S APPROVED SUBJECTS TESTS */
  group('StudentsApprovedSubjects local storage', () {
    test('Shoudl call SharedPreferences to cache the List<StudentsApprovedSubjectsModel>', () async {
      when(mockSharedPreferences.setString(studentsApprovedSubjectsKey, subjectsExpectedJson))
        .thenAnswer((_) => Future.value(true));

      final didCache = await localDataSource.cacheStudentsApprovedSubjects(dummyStdApdSubModel);

      verify(mockSharedPreferences.setString(studentsApprovedSubjectsKey, subjectsExpectedJson));
      expect(didCache, true);
    });

    test('Should return List<StudentsApprovedSubjectsModel> from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(studentsApprovedSubjectsKey)).thenReturn(subjectsExpectedJson);

      final result = await localDataSource.getLastStudentsApprovedSubjects();

      verify(mockSharedPreferences.getString(studentsApprovedSubjectsKey));
      expect(result, dummyStdApdSubModel);
    });

    test('Should throw CacheException when there is not a List<StudentsApprovedSubjectsModel> cached', () async {
      when(mockSharedPreferences.getString(studentsApprovedSubjectsKey)).thenReturn(null);

      final call = localDataSource.getLastStudentsApprovedSubjects;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}