import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_local_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'login_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late LoginLocalDataSource localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LoginLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastLoginSession', () {
    final authUserModel = AuthenticatedUserModel.fromJson(
      json.decode(readFixture('authentication', 'login_cache.json'))
    );

    test('Should return AuthenticatedUserModel from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(authenticatedUserKey))
        .thenReturn(readFixture('authentication', 'login_cache.json'));

      final result = await localDataSource.getLastLoginSession();

      verify(mockSharedPreferences.getString(authenticatedUserKey));
      expect(result, authUserModel);
    });

    test('Should throw CacheException when there is not a cached AuthenticatedUserModel', () async {
      when(mockSharedPreferences.getString(authenticatedUserKey))
        .thenReturn(null);

      final call = localDataSource.getLastLoginSession;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheLoginSession', () {
    final expectedJson = json.encode(dummyAuthUserModel.toJson());
    test('Shoudl call SharedPreferences to cache data', () async {
      when(mockSharedPreferences.setString(authenticatedUserKey, expectedJson))
        .thenAnswer((_) => Future.value(true));

      final didCache = await localDataSource.cacheLoginSession(dummyAuthUserModel);

      verify(mockSharedPreferences.setString(authenticatedUserKey, expectedJson));
      expect(didCache, true);
    });
    // TODO: Make test for when SharedPreferences setString returns false
  });
}