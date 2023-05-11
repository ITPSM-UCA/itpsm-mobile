import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../errors/exceptions/cache/cache_exception.dart';
import '../../../../../constants/constants.dart';
import '../models/enrollment_model.dart';

abstract class EnrollmentLocalDataSource {
  /// Gets the cached [EnrollmentModel] list which was gotten the last time.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<List<EnrollmentModel>> getLastStudentsEnrollments();
  
  /// Caches the [EnrollmentModel] list obtained through the API.
  Future<bool> cacheStudentsEnrollments(List<EnrollmentModel> studentsEnrollments);
}

class EnrollmentLocalDataSourceImpl extends EnrollmentLocalDataSource {
  final SharedPreferences sharedPreferences;

  EnrollmentLocalDataSourceImpl({required this.sharedPreferences});
  
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
}