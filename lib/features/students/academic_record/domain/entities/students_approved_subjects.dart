// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class StudentsApprovedSubjects extends Equatable {
  final int finalScore;
  final int isApproved;
  final int curriculumSubjectId;
  final int periodId;
  final int code;
  final int enrollment;
  final int periodYear;
  final int periodCode;
  final String curriculumSubjectLabel;
  final String curriculumLabel;
  final String careerLabel;
  final String teacherName;

  const StudentsApprovedSubjects({
    required this.finalScore, 
    required this.isApproved, 
    required this.curriculumSubjectId, 
    required this.periodId, 
    required this.code, 
    required this.enrollment, 
    required this.periodYear, 
    required this.periodCode, 
    required this.curriculumSubjectLabel, 
    required this.curriculumLabel, 
    required this.careerLabel, 
    required this.teacherName
  });

  @override
  List<Object> get props {
    return [
      finalScore,
      isApproved,
      curriculumSubjectId,
      periodId,
      code,
      enrollment,
      periodYear,
      periodCode,
      curriculumSubjectLabel,
      curriculumLabel,
      careerLabel,
      teacherName,
    ];
  }
}
