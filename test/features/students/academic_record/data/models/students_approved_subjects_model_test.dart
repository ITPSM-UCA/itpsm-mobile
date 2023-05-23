import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/entities/students_approved_subjects.dart';

import '../../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
    late Map<String, dynamic> response;
    
    setUp(() {
      response = json.decode(readFixture('academic_record', 'getacademichistory_response.json'));
    });

    test('Should be a subclass of StudentsCurricula entity', () async {
      expect(dummyStdApdSubModel, isA<List<StudentsApprovedSubjects>>());
    });

    group('AuthenticatedUserModel from JSON', () { 
      test('Should return a valid StudentsCurriculaModel', () async {
        List<StudentsApprovedSubjectsModel> fromJsonJsonModel = [];
        List<Map<String, dynamic>> jsonModel = ItpsmUtils.getAttributesArrayFromApiResponse(response);

        for (var subject in jsonModel) {
          fromJsonJsonModel.add(StudentsApprovedSubjectsModel.fromJson(subject));
        }

        expect(fromJsonJsonModel, dummyStdApdSubModel);
      });
    });
}