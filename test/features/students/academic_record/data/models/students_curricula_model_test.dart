import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_curricula_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/entities/students_curricula.dart';

import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
    late Map<String, dynamic> response;
    
    setUp(() {
      response = json.decode(readFixture('academic_record', 'student_curricula_response.json'));
    });

    test('Should be a subclass of StudentsCurricula entity', () async {
      expect(dummyStdCurriculaModel, isA<StudentsCurricula>());
    });

    group('AuthenticatedUserModel from JSON', () { 
      test('Should return a valid StudentsCurriculaModel', () async {
        // 
        final Map<String, dynamic> jsonModel = ItpsmUtils.getFirstAttributesArrayFromApiResponse(response);

        final fromJsonJsonModel = StudentsCurriculaModel.fromJson(jsonModel);

        expect(fromJsonJsonModel, dummyStdCurriculaModel);
      });
    });
}