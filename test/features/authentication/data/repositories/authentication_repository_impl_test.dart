import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/authentication/authentication_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/authentication/authentication_failure.dart';
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
  
  // Initilize mocked dependencies for repository
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

      await repository.login(studentEmail, studentPassword);

      verify(mockNetwork.isConnected);
    });
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      // Simulate connection
      setUp(() => when(mockNetwork.isConnected).thenAnswer((_) async => true));

      body(); 
    });
  }

  // void runTestsOffline(Function body) {
  //   group('Device is offline', () {
  //     // Simulate no connection
  //     setUp(() => when(mockNetwork.isConnected).thenAnswer((_) async => false));

  //     body(); 
  //   });
  // }

  runTestsOnline(() {
    test('Should return remote data when the call to remote data source is successful', () async {     
      // Maps the execution of the mock method and returns a fake response 
      when(mockRemoteDataSource.login(studentEmail, studentPassword))
        .thenAnswer((_) async => dummyAuthUserModel);

      // The mocked method should return what we declared on the "when" function
      final result = await repository.login(studentEmail, studentPassword);

      // Verify the mocked method was called
      verify(mockRemoteDataSource.login(studentEmail, studentPassword));

      // Verify the mocked method returned the same dummy data
      expect(result, equals(const Right(dummyAuthUserModel)));
    });

    test('Should cache the data locally when the call to remote data source is successful', () async {     
      // 1. Simulate login remote data source response
      when(mockRemoteDataSource.login(studentEmail, studentPassword))
        .thenAnswer((_) async => dummyAuthUserModel);

      // 2. Get dummy login data
      await repository.login(studentEmail, studentPassword);

      // 3. Verify the login method from the remote data source was executed
      verify(mockRemoteDataSource.login(studentEmail, studentPassword));
      
      // 4. Verify the caching of the dummy login data from the local data source was executed
      verify(mockLocalDataSource.cacheLoginSession(dummyAuthUserModel));
    });

    test('Should return AuthenticationFailure when the call to remote data source is unsuccessful', () async {     
      // 1. Simulate login remote data source method throws [AuthenticationException]  when executed
      when(mockRemoteDataSource.login(studentEmail, studentPassword))
        .thenThrow(const AuthenticationException(title: exceptionTitle, message: exceptionMsg));

      // 2. Get [AuthenticationException]
      final result = await repository.login(studentEmail, studentPassword);

      // 3. Verify the login method from the remote data source was executed
      verify(mockRemoteDataSource.login(studentEmail, studentPassword));

      // Verify that no other method or interaction within the method was executed
      // 4. Verify the caching of the dummy login data from the local data source was not executed
      verifyZeroInteractions(mockLocalDataSource);

      // 5. Verify the repository returns a [AuthenticationFailure] when login the user
      expect(result, equals(const Left(AuthenticationFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when the call to remote data source is unsuccessful', () async {     
      // 1. Simulate login remote data source exception when executed
      when(mockRemoteDataSource.login(studentEmail, studentPassword))
        .thenThrow(Exception());

      // 2. Get [Exception]
      final result = await repository.login(studentEmail, studentPassword);

      // 3. Verify the login method from the remote data source was executed
      verify(mockRemoteDataSource.login(studentEmail, studentPassword));

      // 4. Verify the caching of the dummy login data from the local data source was not executed
      verifyZeroInteractions(mockLocalDataSource);

      // 5. Verify the repository returns a [ServerFailure] when login the user
      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });
  });

  // These tests should be done whenever the user enters the app again. Check if user was logged already or not
  // runTestsOffline(() {
  //   test('Should return last locally cached data when the cached data is present', () async {
  //     // 1. Simulate login local data source response
  //     when(mockLocalDataSource.getLastLoginSession())
  //       .thenAnswer((realInvocation) async => dummyAuthUserModel);

  //     // 2. Get local dummy login data
  //     final result = await repository.login(studentEmail, studentPassword);

  //     // 3. Verify no method from the remote data source was executed
  //     verifyZeroInteractions(mockRemoteDataSource);

  //     // 4. Verify the getLastLoginSession method from the local data source was executed
  //     verify(mockLocalDataSource.getLastLoginSession());

  //     // 5. Verify the getLastLoginSession method returned the same dummy data
  //     expect(result, equals(const Right(dummyAuthUserModel)));
  //   });
    
  //   test('Should return CacheFailure when the cached data is not present', () async {
  //     when(mockLocalDataSource.getLastLoginSession())
  //       .thenThrow(const CacheException(title: exceptionTitle, message: exceptionTitle));

  //     final result = await repository.login(studentEmail, studentPassword);

  //     verifyZeroInteractions(mockRemoteDataSource);
  //     verify(mockLocalDataSource.getLastLoginSession());
  //     expect(result, equals(const Left(CacheFailure(title: failureTitle, cause: failureMsg))));
  //   });
  // });
}