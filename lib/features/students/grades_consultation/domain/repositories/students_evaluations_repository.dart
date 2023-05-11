import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';

import '../../../../../core/errors/failures/failure.dart';

abstract class StudentsEvaluationsRepository {
  Future<Either<Failure, List<StudentsEvaluationsModel>>> getStudentsEvaluations(int studentId, String token, int periodId);
}