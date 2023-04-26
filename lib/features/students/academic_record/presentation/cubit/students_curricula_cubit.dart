import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/cubit/students_curricula_state.dart';
import 'package:logger/logger.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../../domain/repositories/academic_record_repository.dart';

class StudentsCurriculaCubit extends Cubit<StudentsCurriculaState> {
  static final Logger logger = getLogger();

  final AcademicRecordRepository repository;
  
  StudentsCurriculaCubit({required this.repository}) : super(StudentsCurriculaState.initial());

  Future<void> loadStudentsCurricula(AuthenticatedUserModel authUser) async {
    emit(state.copyWith(status: RequestStatus.loading));

    logger.d("Sending student-curricula request to $apiName");

    final result = await repository.getStudentsCurricula(authUser.systemReferenceId, authUser.token);

    if(result.isRight()) {
      emit(state.copyWith(
        status: RequestStatus.loaded,
        studentsCurricula: result.asRight()
      ));
    }
    else {
      emit(state.copyWith(
        status: RequestStatus.failure,
        studentsCurricula: null,
        failure: result.asLeft()
      ));
    }
  }
} 