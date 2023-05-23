

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/cubit/students_approved_subjects_state.dart';
import 'package:logger/logger.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/globals/request_status.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../../../../authentication/data/models/authenticated_user_model.dart';
import '../../domain/repositories/academic_record_repository.dart';

class StudentsApprovedSubjectsCubit extends Cubit<StudentsApprovedSubjectsState> {
  static final Logger logger = getLogger();

  final AcademicRecordRepository repository;
  
  StudentsApprovedSubjectsCubit({required this.repository}) : super(StudentsApprovedSubjectsState.initial());

  Future<void> loadStudentsApprovedSubjects(AuthenticatedUserModel authUser) async {
    emit(state.copyWith(status: RequestStatus.loading));

    logger.d("Sending enrollment/approved-subjects/{studentId} request to $apiName");

    final result = await repository.getStudentsApprovedSubjects(authUser.systemReferenceId, authUser.token);

    if(result.isRight()) {
      emit(state.copyWith(
        subjects: result.asRight(),
        status: RequestStatus.loaded,
      ));
    }
    else {
      emit(state.copyWith(
        subjects: null,
        failure: result.asLeft(),
        status: RequestStatus.failure,
      ));
    }
  }
}