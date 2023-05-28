// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';

import '../../../../../../core/errors/failures/failure.dart';
import '../../../data/models/enrollment_model.dart';

class EnrollmentState extends Equatable {
  final Failure? failure;
  final RequestStatus status;
  final List<EnrollmentModel>? enrollments;
  final EnrollmentModel? selectedEnrollment;

  const EnrollmentState({
    this.failure,
    required this.status,
    this.enrollments,
    this.selectedEnrollment
  });
  
  @override
  List<Object?> get props => [status, enrollments, selectedEnrollment];

  factory EnrollmentState.initial() {
    return const EnrollmentState(
      failure: null,
      status: RequestStatus.initial,
      enrollments: null,
      selectedEnrollment: null
    );
  }

  EnrollmentState copyWith({
    Failure? failure,
    RequestStatus? status,
    List<EnrollmentModel>? enrollments,
    EnrollmentModel? selectedEnrollment
  }) {
    return EnrollmentState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      enrollments: enrollments ?? this.enrollments,
      selectedEnrollment: selectedEnrollment ?? this.selectedEnrollment
    );
  }
}