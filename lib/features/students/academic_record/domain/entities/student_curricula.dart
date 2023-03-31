// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class StudentCurricula extends Equatable {
  final double cum;
  final int entryYear;
  final int uv;
  final int graduationYear;
  final int scholarshipId;
  final int scholarshipRate;
  final int studentId;
  final int curriculumId;
  final String status;
  final int uvTotal;

  const StudentCurricula({
    required this.cum, 
    required this.entryYear, 
    required this.uv, 
    required this.graduationYear, 
    required this.scholarshipId, 
    required this.scholarshipRate, 
    required this.studentId, 
    required this.curriculumId, 
    required this.status, 
    required this.uvTotal
  });

  @override
  List<Object> get props {
    return [
      cum,
      entryYear,
      uv,
      graduationYear,
      scholarshipId,
      scholarshipRate,
      studentId,
      curriculumId,
      status,
      uvTotal,
    ];
  }
}
