import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';

import '../../../../../core/errors/failures/failure.dart';
import '../../../../../core/utils/globals/request_status.dart';

class StudentsApprovedSubjectsState extends Equatable {
  final Failure? failure;
  final RequestStatus status;
  final List<StudentsApprovedSubjectsModel>? subjects;

  const StudentsApprovedSubjectsState({
    this.failure,
    required this.status,
    this.subjects
  });
  
  @override
  List<Object?> get props => [failure, status, subjects];

  factory StudentsApprovedSubjectsState.initial() {
    return const StudentsApprovedSubjectsState(
      failure: null,
      status: RequestStatus.initial,
      subjects: null
    );
  }

  StudentsApprovedSubjectsState copyWith({
    Failure? failure,
    RequestStatus? status,
    List<StudentsApprovedSubjectsModel>? subjects
  }) {
    return StudentsApprovedSubjectsState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      subjects: subjects ?? this.subjects
    );
  }
}