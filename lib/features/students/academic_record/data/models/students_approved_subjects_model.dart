// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/students_approved_subjects.dart';

part 'students_approved_subjects_model.g.dart';

@JsonSerializable()
class StudentsApprovedSubjectsModel extends StudentsApprovedSubjects {
  @override
  @JsonKey(name: 'final_score')
  // ignore: overridden_fields
  final double finalScore;
  @override
  @JsonKey(name: 'is_approved')
  // ignore: overridden_fields
  final int isApproved;
  // @override
  // @JsonKey(name: 'curriculum_subject_id')
  // // ignore: overridden_fields
  // final int curriculumSubjectId;
  // @override
  // @JsonKey(name: 'period_id')
  // // ignore: overridden_fields
  // final int periodId;
  @override
  @JsonKey(name: 'period_year')
  // ignore: overridden_fields
  final int periodYear;
  @override
  @JsonKey(name: 'period_code')
  // ignore: overridden_fields
  final int periodCode;
  // @override
  // @JsonKey(name: 'curriculum_subject_label')
  // // ignore: overridden_fields
  // final String curriculumSubjectLabel;
  // @override
  // @JsonKey(name: 'curriculum_label')
  // // ignore: overridden_fields
  // final String curriculumLabel;
  // @override
  // @JsonKey(name: 'career_label')
  // // ignore: overridden_fields
  // final String careerLabel;
  @override
  @JsonKey(name: 'teachername')
  // ignore: overridden_fields
  final String teacherName;

  const StudentsApprovedSubjectsModel({
    required super.name,
    required this.finalScore, 
    required this.isApproved, 
    // required this.curriculumSubjectId, 
    // required this.periodId, 
    // required super.code, 
    required super.enrollment, 
    required this.periodYear, 
    required this.periodCode, 
    // required this.curriculumSubjectLabel, 
    // required this.curriculumLabel, 
    // required this.careerLabel, 
    required this.teacherName
  }) : super(
    finalScore: finalScore, 
    isApproved: isApproved, 
    // curriculumSubjectId: curriculumSubjectId, 
    // periodId: periodId, 
    periodYear: periodYear, 
    periodCode: periodCode, 
    // curriculumSubjectLabel: curriculumSubjectLabel, 
    // curriculumLabel: curriculumLabel, 
    // careerLabel: careerLabel, 
    teacherName: teacherName
  );

  factory StudentsApprovedSubjectsModel.emptyDummy() {
    return const StudentsApprovedSubjectsModel(
      name: 'Preparación de bebidas',
      isApproved: 1,
      enrollment: 4,
      finalScore: 9,
      teacherName: 'Arthur Morgan',
      periodCode: 1,
      periodYear: 2023
    );
  }

  factory StudentsApprovedSubjectsModel.fromJson(Map<String, dynamic> json) => _$StudentsApprovedSubjectsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsApprovedSubjectsModelToJson(this);

  String get isApprovedText {
    switch(isApproved) {
      case 0: return 'Reprobada';
      case 1: return 'Aprobada';
      default: return 'Pendiente'; 
    }
  }

  StudentsApprovedSubjectsModel copyWith({
    double? finalScore,
    int? isApproved,
    int? periodYear,
    int? periodCode,
    String? teacherName,
    int? enrollment,
    String? name,
  }) {
    return StudentsApprovedSubjectsModel(
      finalScore: finalScore ?? this.finalScore,
      isApproved: isApproved ?? this.isApproved,
      periodYear: periodYear ?? this.periodYear,
      periodCode: periodCode ?? this.periodCode,
      teacherName: teacherName ?? this.teacherName,
      enrollment: enrollment ?? super.enrollment,
      name: name ?? super.name
    );
  }
}
