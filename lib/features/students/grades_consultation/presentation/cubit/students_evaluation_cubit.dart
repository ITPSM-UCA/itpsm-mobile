import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/domain/repositories/students_evaluations_repository.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/cubit/students_evaluation_state.dart';
import 'package:logger/logger.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/globals/request_status.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../../../../authentication/data/models/authenticated_user_model.dart';

class StudentsEvaluationsCubit extends Cubit<StudentsEvaluationsState> {
  static final Logger logger = getLogger();

  final StudentsEvaluationsRepository repository;
  
  StudentsEvaluationsCubit({required this.repository}) : super(StudentsEvaluationsState.initial());

  Future<void> loadStudentsEvaluations(AuthenticatedUserModel authUser, int periodId) async {
    emit(state.copyWith(status: RequestStatus.loading));

    logger.d("Sending evaluations/student request to $apiName");

    final result = await repository.getStudentsEvaluations(authUser.systemReferenceId, authUser.token, periodId);

    if(result.isRight()) {
      emit(state.copyWith(
        status: RequestStatus.loaded,
        evaluations: result.asRight()
      ));
    }
    else {
      emit(state.copyWith(
        status: RequestStatus.failure,
        evaluations: null,
        failure: result.asLeft()
      ));
    }
  }
}