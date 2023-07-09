import 'package:equatable/equatable.dart';

abstract class StudentsEvaluations extends Equatable {
  final int id;
  final String name;
  final String? description;
  final DateTime date;
  final int percentage;
  final int? principalId;
  final int sectionId;
  final int? status;
  final double? evaluationScore;
  final int periodId;
  final int subjectId;
  final String subjectName;
  final double? subjectFinalScore;
  final List<StudentsEvaluations>? subevaluations;

  const StudentsEvaluations({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.date, 
    required this.percentage, 
    this.principalId, 
    required this.sectionId,
    this.status, 
    required this.evaluationScore, 
    required this.periodId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectFinalScore,
    this.subevaluations
  });

  @override
  List<Object> get props => [id, name, date, percentage, sectionId, periodId, subjectId, subjectName];
}