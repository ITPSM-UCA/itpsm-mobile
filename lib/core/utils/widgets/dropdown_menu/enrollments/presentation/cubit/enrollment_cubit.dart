import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/models/enrollment_model.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/domain/repositories/enrollment_repository.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/presentation/cubit/enrollment_state.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:logger/logger.dart';

import '../../../../../constants/constants.dart';
import '../../../../../log/get_logger.dart';

class EnrollmentCubit extends Cubit<EnrollmentState> {
  static final Logger logger = getLogger();

  final EnrollmentRepository repository;
  
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