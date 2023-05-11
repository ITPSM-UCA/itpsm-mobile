import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/authentication/domain/entities/authenticated_user.dart';
import '../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
    late Map<String, dynamic> response;
    
    // Does everything declared in this scope before running any test
    setUp(() {
      response = json.decode(readFixture('authentication', 'login_response.json'));
    });

    test('Should be a subclass of AuthenticatedUser entity', () async {
      // Compares 
      expect(dummyAuthUserModel, isA<AuthenticatedUser>());
    });

    group('AuthenticatedUserModel from JSON', () { 
      test('Should return a valid AuthenticatedUserModel', () async {
        final Map<String, dynamic> jsonAuthUserModel = ItpsmUtils.parseAuthenticationApiResponse(response);

        final fromJsonAuthUserModel = AuthenticatedUserModel.fromJson(jsonAuthUserModel);

        expect(fromJsonAuthUserModel, dummyAuthUserModel);
      });
    });
}