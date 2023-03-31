import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/students_curricula.dart';

part 'students_curricula_model.g.dart';

@JsonSerializable()
class StudentsCurriculaModel extends StudentsCurricula {
  @override
  @JsonKey(name: 'entry_year')
  // ignore: overridden_fields
  final int entryYear;
  @override
  @JsonKey(name: 'graduation_year')
  // ignore: overridden_fields
  final int graduationYear;
  @override
  @JsonKey(name: 'scholarship_id')
  // ignore: overridden_fields
  final int scholarshipId;
  @override
  @JsonKey(name: 'scholarship_rate')
  // ignore: overridden_fields
  final int scholarshipRate;
  @override
  @JsonKey(name: 'student_id')
  // ignore: overridden_fields
  final int studentId;
  @override
  @JsonKey(name: 'curriculum_id')
  // ignore: overridden_fields
  final int curriculumId;
  @override
  @JsonKey(name: 'uv_total')
  // ignore: overridden_fields
  final int uvTotal;
  
  const StudentsCurriculaModel({
    required super.cum, 
    required this.entryYear, 
    required super.uv, 
    required this.graduationYear, 
    required this.scholarshipId, 
    required this.scholarshipRate, 
    required this.studentId, 
    required this.curriculumId, 
    required super.status, 
    required this.uvTotal
  }) : super(
    entryYear: entryYear, 
    graduationYear: graduationYear, 
    scholarshipId: scholarshipId,
    scholarshipRate: scholarshipRate,
    studentId: studentId,
    curriculumId: curriculumId,
    uvTotal: uvTotal
  );

  factory StudentsCurriculaModel.fromJson(Map<String, dynamic> json) => _$StudentsCurriculaModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsCurriculaModelToJson(this);
}