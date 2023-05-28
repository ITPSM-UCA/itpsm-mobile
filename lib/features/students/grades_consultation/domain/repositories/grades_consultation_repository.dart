import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';

import '../../../../../core/errors/failures/failure.dart';
import '../../data/models/enrollment_model.dart';

abstract class GradesConsultationRepository {
  Future<Either<Failure, List<EnrollmentModel>>> getStudentsEnrollments(int studentId, String token);
  Future<Either<Failure, List<StudentsEvaluationsModel>>> getStudentsEvaluations(int studentId, String token, int periodId);
}