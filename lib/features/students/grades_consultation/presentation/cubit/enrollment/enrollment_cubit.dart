import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/domain/repositories/grades_consultation_repository.dart';
import 'package:logger/logger.dart';

import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/utils/log/get_logger.dart';
import '../../../data/models/enrollment_model.dart';
import 'enrollment_state.dart';

class EnrollmentCubit extends Cubit<EnrollmentState> {
  static final Logger logger = getLogger();

  final GradesConsultationRepository repository;
  
  EnrollmentCubit({required this.repository}) : super(EnrollmentState.initial());

  Future<void> loadEnrollments(AuthenticatedUserModel authUser, [isStudentsEnrollment = true]) async {
    emit(state.copyWith(status: RequestStatus.loading));

    logger.d("Sending enrollments_student request to $apiName");

    // In case of needing a general periods call
    // if(!isStudentsEnrollment) {
    //   final result = await repository.getStudentsEnrollments(authUser.systemReferenceId, authUser.token);
    // }

    final result = await repository.getStudentsEnrollments(authUser.systemReferenceId, authUser.token);

    if(result.isRight()) {
      emit(state.copyWith(
        status: RequestStatus.loaded,
        enrollments: result.asRight()
      ));
    }
    else {
      emit(state.copyWith(
        status: RequestStatus.failure,
        enrollments: null,
        failure: result.asLeft()
      ));
    }
  }

  void selectEnrollment(EnrollmentModel? enrollment) {
    emit(state.copyWith(selectedEnrollment: enrollment));
  }
} 