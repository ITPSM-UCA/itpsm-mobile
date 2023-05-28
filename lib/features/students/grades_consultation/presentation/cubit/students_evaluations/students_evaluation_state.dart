import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures/failure.dart';
import '../../../../../../core/utils/globals/request_status.dart';
import '../../../data/models/students_evaluations_model.dart';

class StudentsEvaluationsState extends Equatable {
  final Failure? failure;
  final RequestStatus status;
  final List<StudentsEvaluationsModel>? evaluations;

  const StudentsEvaluationsState({
    this.failure,
    required this.status,
    this.evaluations
  });
  
  @override
  List<Object?> get props => [failure, status, evaluations];

  factory StudentsEvaluationsState.initial() {
    return const StudentsEvaluationsState(
      failure: null,
      status: RequestStatus.initial,
      evaluations: null
    );
  }

  StudentsEvaluationsState copyWith({
    Failure? failure,
    RequestStatus? status,
    List<StudentsEvaluationsModel>? evaluations
  }) {
    return StudentsEvaluationsState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      evaluations: evaluations ?? this.evaluations
    );
  }
}