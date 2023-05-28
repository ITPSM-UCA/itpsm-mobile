import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/enrollment_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/domain/entities/enrollment.dart';

import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
    late Map<String, dynamic> response;
    
    setUp(() {
      response = json.decode(readFixture('grades_consultation', 'enrollments_student_response.json'));
    });

    test('Should be a subclass of Enrollment entity', () async {
      expect(dummyStdEmts, isA<List<Enrollment>>());
    });

    group('Enrollment from JSON', () { 
      test('Should return a valid Enrollment', () async {
        List<EnrollmentModel> fromJsonJsonModel = [];
        Map<String, dynamic> attributes = ItpsmUtils.getAttributesObjectFromApiResponse(response);
        List<Map<String, dynamic>> jsonModel = (attributes['enrollment'] as List).map((e) => e as Map<String, dynamic>).toList();

        for (var enrollment in jsonModel) {
          fromJsonJsonModel.add(EnrollmentModel.fromJson(enrollment));
        }

        expect(fromJsonJsonModel, dummyStdEmts);
      });
    });
}