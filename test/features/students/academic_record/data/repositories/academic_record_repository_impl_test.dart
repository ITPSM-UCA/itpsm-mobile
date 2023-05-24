import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/cache/cache_failure.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_local_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_remote_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/repositories/academic_record_repository_impl.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/repositories/academic_record_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import 'academic_record_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AcademicRecordRemoteDataSource>(),
  MockSpec<AcademicRecordLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  late MockAcademicRecordRemoteDataSource mockRemoteDataSource;
  late MockAcademicRecordLocalDataSource mockLocalDataSource;
  late AcademicRecordRepository repository;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemoteDataSource = MockAcademicRecordRemoteDataSource();
    mockLocalDataSource = MockAcademicRecordLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = AcademicRecordRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      network: mockNetwork
    );
  });

  group('AcademicRecord network check', () {
    test('Should check if device has internet connection', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);

      await repository.getStudentsCurricula(studentId, token);

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

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      // Simulate no connection
      setUp(() => when(mockNetwork.isConnected).thenAnswer((_) async => false));

      body(); 
    });
  }

  runTestsOnline(() {
    /* STUDENT'S CURRICULA TESTS */
    test('Should return Right<StudentsCurriculaModel> when getStudentsCurricula method is successful', () async {   
      when(mockRemoteDataSource.getStudentsCurricula(studentId, token))
        .thenAnswer((_) async => dummyStdCurriculaModel);

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockRemoteDataSource.getStudentsCurricula(studentId, token));

      expect(result, equals(const Right(dummyStdCurriculaModel)));
    });

    test('Should cache the StudentsCurriculaModel locally when the getStudentsCurricula method is successful', () async {     
      when(mockRemoteDataSource.getStudentsCurricula(studentId, token))
        .thenAnswer((_) async => dummyStdCurriculaModel);

      await repository.getStudentsCurricula(studentId, token);

      verify(mockRemoteDataSource.getStudentsCurricula(studentId, token));
      
      verify(mockLocalDataSource.cacheStudentsCurricula(dummyStdCurriculaModel));
    });

    test('Should return ServerFailure when getStudentsCurricula method throws ServerException', () async {     
      when(mockRemoteDataSource.getStudentsCurricula(studentId, token))
        .thenThrow(const ServerException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockRemoteDataSource.getStudentsCurricula(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsCurricula method throws Exception', () async {     
      when(mockRemoteDataSource.getStudentsCurricula(studentId, token))
        .thenThrow(Exception());

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockRemoteDataSource.getStudentsCurricula(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    /* STUDENT'S APPROVED SUBJECTS TESTS */
    test('Should return Right<List<StudentsApprovedSubjectsModel>> when getStudentsApprovedSubjects method is successful', () async {   
      when(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token))
        .thenAnswer((_) async => dummyStdApdSubModel);

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token));

      expect(result, equals(const Right(dummyStdApdSubModel)));
    });

    test('Should cache the List<StudentsApprovedSubjectsModel> locally when the getStudentsApprovedSubjects method is successful', () async {     
      when(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token))
        .thenAnswer((_) async => dummyStdApdSubModel);

      await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token));
      
      verify(mockLocalDataSource.cacheStudentsApprovedSubjects(dummyStdApdSubModel));
    });

    test('Should return ServerFailure when getStudentsApprovedSubjects method throws ServerException', () async {     
      when(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token))
        .thenThrow(const ServerException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsApprovedSubjects method throws Exception', () async {     
      when(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token))
        .thenThrow(Exception());

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockRemoteDataSource.getStudentsApprovedSubjects(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });
  });

  runTestsOffline(() {
    /* STUDENT'S CURRICULA TESTS */
    test('Should return Right<StudentsCurriculaModel> when getStudentsCurricula method is called and device is offline', () async {   
      when(mockLocalDataSource.getLastStudentsCurricula())
        .thenAnswer((_) async => dummyStdCurriculaModel);

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockLocalDataSource.getLastStudentsCurricula());

      expect(result, equals(const Right(dummyStdCurriculaModel)));
    });

    test('Should return CacheFailure when getStudentsCurricula method throws CacheException', () async {     
      when(mockLocalDataSource.getLastStudentsCurricula())
        .thenThrow(const CacheException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockLocalDataSource.getLastStudentsCurricula());

      expect(result, equals(const Left(CacheFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsCurricula method throws Exception', () async {     
      when(mockLocalDataSource.getLastStudentsCurricula())
        .thenThrow(Exception());

      final result = await repository.getStudentsCurricula(studentId, token);

      verify(mockLocalDataSource.getLastStudentsCurricula());

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    /* STUDENT'S APPROVED SUBJECTS TESTS */
    test('Should return Right<List<StudentsApprovedSubjectsModel>> when getStudentsApprovedSubjects method is called and device is offline', () async {   
      when(mockLocalDataSource.getLastStudentsApprovedSubjects())
        .thenAnswer((_) async => dummyStdApdSubModel);

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockLocalDataSource.getLastStudentsApprovedSubjects());

      expect(result, equals(const Right(dummyStdApdSubModel)));
    });

    test('Should return CacheFailure when getStudentsApprovedSubjects method throws CacheException', () async {     
      when(mockLocalDataSource.getLastStudentsApprovedSubjects())
        .thenThrow(const CacheException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockLocalDataSource.getLastStudentsApprovedSubjects());

      expect(result, equals(const Left(CacheFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsApprovedSubjects method throws Exception', () async {     
      when(mockLocalDataSource.getLastStudentsApprovedSubjects())
        .thenThrow(Exception());

      final result = await repository.getStudentsApprovedSubjects(studentId, token);

      verify(mockLocalDataSource.getLastStudentsApprovedSubjects());

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });
  });
}