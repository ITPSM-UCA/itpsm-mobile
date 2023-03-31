import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  /// Caches the [StudentsApprovedSubjectsModel] obtained through the API.
  Future<bool> cacheStudentsApprovedSubjects(StudentsApprovedSubjectsModel studentCurricula);
}

class AcademicRecordLocalDataSourceImpl extends AcademicRecordLocalDataSource {
  final SharedPreferences sharedPreferences;

  AcademicRecordLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<bool> cacheStudentsCurricula(StudentsCurriculaModel studentCurricula) {
    // TODO: implement cacheStudentCurricula
    throw UnimplementedError();
  }

  @override
  Future<StudentsCurriculaModel> getLastStudentsCurricula() {
    // TODO: implement getLastStudentCurricula
    throw UnimplementedError();
  }
  
  @override
  Future<bool> cacheStudentsApprovedSubjects(StudentsApprovedSubjectsModel studentCurricula) {
    // TODO: implement cacheStudentsApprovedSubjects
    throw UnimplementedError();
  }
  
  @override
  Future<List<StudentsApprovedSubjectsModel>> getLastStudentsApprovedSubjects() {
    // TODO: implement getLastStudentsApprovedSubjects
    throw UnimplementedError();
  }

}