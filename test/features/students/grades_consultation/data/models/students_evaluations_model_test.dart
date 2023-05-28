import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/domain/entities/students_evaluation.dart';

import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
    late Map<String, dynamic> response;
    
    setUp(() {
      response = json.decode(readFixture('grades_consultation', 'students_evaluations_response.json'));
    });

    test('Should be a subclass of StudentsEvaluations entity', () async {
      expect(dummyStdEvsModel, isA<List<StudentsEvaluations>>());
    });

    group('StudentsEvaluations from JSON', () { 
      test('Should return a valid StudentsEvaluations', () async {
        List<StudentsEvaluationsModel> fromJsonJsonModel = [];
        List<Map<String, dynamic>> jsonModel = ItpsmUtils.getAttributesArrayFromApiResponse(response);

        for (var subject in jsonModel) {
          fromJsonJsonModel.add(StudentsEvaluationsModel.fromJson(subject));
        }

        expect(fromJsonJsonModel, dummyStdEvsModel);
      });
    });
}