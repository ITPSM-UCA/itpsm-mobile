import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';

import '../../data/models/students_curricula_model.dart';

abstract class AcademicRecordRepository {
  Future<Either<Failure, StudentsCurriculaModel>> getStudentsCurricula(int studentId, String token);
  Future<Either<Failure, List<StudentsApprovedSubjectsModel>>> getStudentsApprovedSubjects(int studentId, String token);
}