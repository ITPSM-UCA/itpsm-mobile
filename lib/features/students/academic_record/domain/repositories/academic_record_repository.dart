import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/entities/students_approved_subjects.dart';

import '../../data/models/students_curricula_model.dart';

abstract class AcademicRecordRepository {
  Future<Either<Failure, StudentsCurriculaModel>> getStudentsCurricula(int studentId);
  Future<Either<Failure, List<StudentsApprovedSubjects>>> getStudentsApprovedSubjects();
}