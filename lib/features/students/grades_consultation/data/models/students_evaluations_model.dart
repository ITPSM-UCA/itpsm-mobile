// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/students_evaluation.dart';

part 'students_evaluations_model.g.dart';

@JsonSerializable()
class StudentsEvaluationsModel extends StudentsEvaluations {
  @override
  @JsonKey(name: 'principal_id')
  // ignore: overridden_fields
  final int? principalId;
  @override
  @JsonKey(name: 'evaluation_score')
  // ignore: overridden_fields
  final double evaluationScore;
  @override
  @JsonKey(name: 'section_id')
  // ignore: overridden_fields
  final int sectionId;
  @override
  @JsonKey(name: 'period_id')
  // ignore: overridden_fields
  final int periodId;
  @override
  @JsonKey(name: 'subject_id')
  // ignore: overridden_fields
  final int subjectId;
  @override
  @JsonKey(name: 'subject_name')
  // ignore: overridden_fields
  final String subjectName;
  @override
  @JsonKey(name: 'subject_final_core')
  // ignore: overridden_fields
  final double subjectFinalScore;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  // ignore: overridden_fields
  final List<StudentsEvaluationsModel>? subevaluations;

  const StudentsEvaluationsModel({
    required super.id, 
    required super.name, 
    required super.description,
    required super.date, 
    required super.percentage, 
    this.principalId, 
    required this.sectionId,
    super.status,
    required this.evaluationScore,
    required this.periodId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectFinalScore,
    this.subevaluations = const []
  }) : super(evaluationScore: evaluationScore, sectionId: sectionId, periodId: periodId, subjectId: subjectId, subjectName: subjectName, subjectFinalScore: subjectFinalScore);

  factory StudentsEvaluationsModel.fromJson(Map<String, dynamic> json) => _$StudentsEvaluationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsEvaluationsModelToJson(this);

  StudentsEvaluationsModel copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? percentage,
    int? status,
    double? evaluationScore,
    int? principalId,
    int? sectionId,
    int? periodId,
    int? subjectId,
    String? subjectName,
    double? subjectFinalScore,
    List<StudentsEvaluationsModel>? subevaluations,
  }) {
    return StudentsEvaluationsModel(
      id: id ?? super.id,
      name: name ?? super.name, 
      description: description ?? super.description,
      date: date ?? super.date, 
      percentage: percentage ?? super.percentage, 
      status: status ?? super.status,
      evaluationScore: evaluationScore ?? super.evaluationScore,
      principalId: principalId ?? this.principalId,
      sectionId: sectionId ?? this.sectionId,
      periodId: periodId ?? this.periodId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectFinalScore: subjectFinalScore ?? this.subjectFinalScore,
      subevaluations: subevaluations ?? this.subevaluations,
    );
  }
}
