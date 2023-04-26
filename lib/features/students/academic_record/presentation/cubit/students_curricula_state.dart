// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_curricula_model.dart';

import '../../../../../core/errors/failures/failure.dart';

class StudentsCurriculaState extends Equatable {
  final Failure? failure;
  final RequestStatus status;
  final StudentsCurriculaModel? studentsCurricula;

  const StudentsCurriculaState({
    this.failure,
    required this.status,
    this.studentsCurricula
  });
  
  @override
  List<Object?> get props => [status, studentsCurricula];

  factory StudentsCurriculaState.initial() {
    return const StudentsCurriculaState(
      failure: null,
      status: RequestStatus.initial,
      studentsCurricula: null
    );
  }

  StudentsCurriculaState copyWith({
    Failure? failure,
    RequestStatus? status,
    StudentsCurriculaModel? studentsCurricula
  }) {
    return StudentsCurriculaState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      studentsCurricula: studentsCurricula ?? this.studentsCurricula
    );
  }
}
