import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/models/enrollment_model.dart';

import '../../../../../../errors/failures/failure.dart';

abstract class EnrollmentRepository {
  Future<Either<Failure, List<EnrollmentModel>>> getStudentsEnrollments(int studentId, String token);
}