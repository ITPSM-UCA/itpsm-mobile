import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/errors/exceptions/cache/cache_exception.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../models/enrollment_model.dart';
import '../models/students_evaluations_model.dart';

abstract class GradesConsultationLocalDataSource {
  /// Gets the cached [EnrollmentModel] list which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<List<EnrollmentModel>> getLastStudentsEnrollments();
  
  /// Caches the [EnrollmentModel] list obtained through the API.
  Future<bool> cacheStudentsEnrollments(List<EnrollmentModel> studentsEnrollments);
  
  /// Gets the cached [StudentsEvaluationsModel] list which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<List<StudentsEvaluationsModel>> getLastStudentsEvaluations();
  
  /// Caches the [StudentsEvaluationsModel] list obtained through the API.
  Future<bool> cacheStudentsEvaluations(List<StudentsEvaluationsModel> studentsEvaluations);
}

class GradesConsultationLocalDataSourceImpl extends GradesConsultationLocalDataSource {
  final SharedPreferences sharedPreferences;

  GradesConsultationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheStudentsEnrollments(List<EnrollmentModel> studentsEnrollments) {
    final List<Map<String, dynamic>> jsonSubjects = [];

    for (var enrollment in studentsEnrollments) {
      jsonSubjects.add(enrollment.toJson());
    }
    
    return Future.value(sharedPreferences.setString(studentsEnrollmentsKey, json.encode(jsonSubjects)));
  }
  
  @override
  Future<List<EnrollmentModel>> getLastStudentsEnrollments() {
    final jsonString = sharedPreferences.getString(studentsEnrollmentsKey);

    if(jsonString != null) {
      List<EnrollmentModel> subjects = [];
      final List<Map<String, dynamic>> jsonSubjects = json.decode(jsonString);

      for (var subject in jsonSubjects) {
        subjects.add(EnrollmentModel.fromJson(subject));
      }

      return Future.value(subjects);
    }
    else {
      throw const CacheException(title: 'Local student\'s enrollments not found', message: 'A local copy of the student\'s enrollments were not found');
    }
  }

  @override
  Future<bool> cacheStudentsEvaluations(List<StudentsEvaluationsModel> studentsEvaluations) {
    final List<Map<String, dynamic>> jsonEvaluations = [];

    for (var evaluation in studentsEvaluations) {
      jsonEvaluations.add(evaluation.toJson());
    }
    
    return Future.value(sharedPreferences.setString(studentsEvaluationsKey, json.encode(jsonEvaluations)));
  }

  @override
  Future<List<StudentsEvaluationsModel>> getLastStudentsEvaluations() {
    final jsonString = sharedPreferences.getString(studentsEvaluationsKey);

    if(jsonString != null) {
      List<StudentsEvaluationsModel> evaluations = [];
      final List<Map<String, dynamic>> jsonEvaluations = json.decode(jsonString);

      for (var evaluation in jsonEvaluations) {
        evaluations.add(StudentsEvaluationsModel.fromJson(evaluation));
      }

      return Future.value(evaluations);
    }
    else {
      throw const CacheException(title: 'Local student\'s evaluations not found', message: 'A local copy of the student\'s evaluations were not found');
    }
  }
}