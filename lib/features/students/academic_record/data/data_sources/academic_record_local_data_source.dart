import 'dart:convert';

import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/errors/exceptions/cache/cache_exception.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../models/students_curricula_model.dart';

abstract class AcademicRecordLocalDataSource {
  /// Gets the cached [StudentCurriculaModel] which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<StudentsCurriculaModel> getLastStudentsCurricula();
  
  /// Caches the [StudentCurriculaModel] obtained through the API.
  Future<bool> cacheStudentsCurricula(StudentsCurriculaModel studentCurricula);
  
  /// Gets the cached [StudentsApprovedSubjectsModel] list which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<List<StudentsApprovedSubjectsModel>> getLastStudentsApprovedSubjects();

  /// Caches the [StudentsApprovedSubjectsModel] list obtained through the API.
  Future<bool> cacheStudentsApprovedSubjects(List<StudentsApprovedSubjectsModel> studentsApprovedSubjects);
}

class AcademicRecordLocalDataSourceImpl extends AcademicRecordLocalDataSource {
  final SharedPreferences sharedPreferences;

  AcademicRecordLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<bool> cacheStudentsCurricula(StudentsCurriculaModel studentCurricula) {
    final studentCurriculaToCache = json.encode(studentCurricula.toJson());
    
    return Future.value(sharedPreferences.setString(studentsCurriculaKey, studentCurriculaToCache));
  }

  @override
  Future<StudentsCurriculaModel> getLastStudentsCurricula() {
    final jsonString = sharedPreferences.getString(studentsCurriculaKey);

    if(jsonString != null) {
      return Future.value(StudentsCurriculaModel.fromJson(json.decode(jsonString)));
    }
    else {
      throw const CacheException(title: 'Local student\'s curricula not found', message: 'A local copy of the student\'s curricula was not found');
    }
  }
  
  @override
  Future<bool> cacheStudentsApprovedSubjects(List<StudentsApprovedSubjectsModel> studentsApprovedSubjects) {
    final List<Map<String, dynamic>> jsonSubjects = [];

    for (var subject in studentsApprovedSubjects) {
      jsonSubjects.add(subject.toJson());
    }
    
    return Future.value(sharedPreferences.setString(studentsApprovedSubjectsKey, json.encode(jsonSubjects)));
  }
  
  @override
  Future<List<StudentsApprovedSubjectsModel>> getLastStudentsApprovedSubjects() {
    final jsonString = sharedPreferences.getString(studentsApprovedSubjectsKey);

    if(jsonString != null) {
      List<StudentsApprovedSubjectsModel> subjects = [];
      final List<Map<String, dynamic>> jsonSubjects = (json.decode(jsonString) as List).map((e) => e as Map<String, dynamic>).toList();

      for (var subject in jsonSubjects) {
        subjects.add(StudentsApprovedSubjectsModel.fromJson(subject));
      }

      return Future.value(subjects);
    }
    else {
      throw const CacheException(title: 'Local student\'s approved subjects not found', message: 'A local copy of the student\'s approved subjects were not found');
    }
  }

}