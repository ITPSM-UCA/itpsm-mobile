import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/domain/entities/enrollment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enrollment_model.g.dart';

@JsonSerializable()
class EnrollmentModel extends Enrollment {
  const EnrollmentModel({
    required super.id, 
    required super.code, 
    required super.year, 
    required super.status
  });

  factory EnrollmentModel.empty() => const EnrollmentModel(
    id: 0,
    code: 0,
    status: '',
    year: 0
  );

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) => _$EnrollmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentModelToJson(this);

  String get periodText {
    return 'Ciclo $code - $year';
  }
}