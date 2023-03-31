import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';

import '../../domain/entities/students_curricula.dart';

abstract class AcademicRecordRemoteDataSource {
  /// Calls the http://itpsm-api-host/api/student-curricula endpoint and gets the student's curricula.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<StudentsCurricula> getStudentsCurricula(int studentId);

  /// Calls the http://itpsm-api-host/api/enrollment/approved-subjects endpoint and gets the student's approved subjects.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<StudentsApprovedSubjectsModel>> getStudentsApprovedSubjects();
}

class AcademicRecordDataSourceImpl extends AcademicRecordRemoteDataSource {
  final http.Client client;

  AcademicRecordDataSourceImpl({required this.client});
  
  @override
  Future<StudentsCurricula> getStudentsCurricula(int studentId) {
    // TODO: implement getStudentCurricula
    throw UnimplementedError();
  }
  
  @override
  Future<List<StudentsApprovedSubjectsModel>> getStudentsApprovedSubjects() {
    // TODO: implement getStudentsApprovedSubjects
    throw UnimplementedError();
  }
}