import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/cache/cache_failure.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_local_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_remote_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:itpsm_mobile/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/dummies/models/dummy_models.dart';
import 'authentication_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginRemoteDataSource>(),
  MockSpec<LoginLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  late MockLoginRemoteDataSource mockRemoteDataSource;
  late MockLoginLocalDataSource mockLocalDataSource;
  late AuthenticationRepository repository;
  late MockNetworkInfo mockNetwork;
  
  setUp(() {
    mockRemoteDataSource = MockLoginRemoteDataSource();
    mockLocalDataSource = MockLoginLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      network: mockNetwork
    );
  });

  group('Login network check', () {
    test('Should check if device has internet connection', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);

      await repository.login(adminEmail, adminPassword);

      verify(mockNetwork.isConnected);
    });
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      setUp(() => when(mockNetwork.isConnected).thenAnswer((_) async => true));

      body(); 
    });
  }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() => when(mockNetwork.isConnected).thenAnswer((_) async => false));

      body(); 
    });
  }

  runTestsOnline(() {
    test('Should return remote data when the call to remote data source is successful', () async {     
      when(mockRemoteDataSource.login(adminEmail, adminPassword))
        .thenAnswer((_) async => dummyAuthUserModel);

      final result = await repository.login(adminEmail, adminPassword);

      verify(mockRemoteDataSource.login(adminEmail, adminPassword));
      expect(result, equals(const Right(dummyAuthUserModel)));
    });

    test('Should cache the data locally when the call to remote data source is successful', () async {     
      when(mockRemoteDataSource.login(adminEmail, adminPassword))
        .thenAnswer((_) async => dummyAuthUserModel);

      await repository.login(adminEmail, adminPassword);

      verify(mockRemoteDataSource.login(adminEmail, adminPassword));
      verify(mockLocalDataSource.cacheLoginSession(dummyAuthUserModel));
    });

    test('Should return ServerFailure when the call to remote data source is unsuccessful', () async {     
      when(mockRemoteDataSource.login(adminEmail, adminPassword))
        .thenThrow(ServerException());

      final result = await repository.login(adminEmail, adminPassword);

      verify(mockRemoteDataSource.login(adminEmail, adminPassword));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(const Left(ServerFailure())));
    });
  });

  runTestsOffline(() {
    test('Should return last locally cached data when the cached data is present', () async {
      when(mockLocalDataSource.getLastLoginSession())
        .thenAnswer((realInvocation) async => dummyAuthUserModel);

      final result = await repository.login(adminEmail, adminPassword);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastLoginSession());
      expect(result, equals(const Right(dummyAuthUserModel)));
    });
    
    test('Should return CacheFailure when the cached data is not present', () async {
      when(mockLocalDataSource.getLastLoginSession())
        .thenThrow(CacheException());

      final result = await repository.login(adminEmail, adminPassword);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastLoginSession());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}