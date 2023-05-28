import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_data_source.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_local_data_source.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/repositories/grades_consultation_repository_impl.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/domain/repositories/grades_consultation_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/dummies/models/dummy_models.dart';
import 'grades_consultation_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GradesConsultationRemoteDataSource>(),
  MockSpec<GradesConsultationLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  late MockGradesConsultationRemoteDataSource mockRemoteDataSource;
  late MockGradesConsultationLocalDataSource mockLocalDataSource;
  late GradesConsultationRepository repository;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemoteDataSource = MockGradesConsultationRemoteDataSource();
    mockLocalDataSource = MockGradesConsultationLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = GradesConsultationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      network: mockNetwork
    );
  });

  group('GradesConsultationRepository network check', () {
    test('Should check if device has internet connection', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);

      await repository.getStudentsEnrollments(studentId, token);

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
    /* STUDENT'S ENROLLMENTS TESTS */
    test('Should return Right<List<EnrollmentModel>> when getStudentsEnrollments method is successful', () async {   
      when(mockRemoteDataSource.getStudentsEnrollments(studentId, token))
        .thenAnswer((_) async => dummyStdEmts);

      final result = await repository.getStudentsEnrollments(studentId, token);

      verify(mockRemoteDataSource.getStudentsEnrollments(studentId, token));

      expect(result, equals(const Right(dummyStdEmts)));
    });

    test('Should cache the List<EnrollmentModel> locally when the getStudentsEnrollments method is successful', () async {     
      when(mockRemoteDataSource.getStudentsEnrollments(studentId, token))
        .thenAnswer((_) async => dummyStdEmts);

      await repository.getStudentsEnrollments(studentId, token);

      verify(mockRemoteDataSource.getStudentsEnrollments(studentId, token));
      
      verify(mockLocalDataSource.cacheStudentsEnrollments(dummyStdEmts));
    });

    test('Should return ServerFailure when getStudentsEnrollments method throws ServerException', () async {     
      when(mockRemoteDataSource.getStudentsEnrollments(studentId, token))
        .thenThrow(const ServerException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsEnrollments(studentId, token);

      verify(mockRemoteDataSource.getStudentsEnrollments(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsEnrollments method throws Exception', () async {     
      when(mockRemoteDataSource.getStudentsEnrollments(studentId, token))
        .thenThrow(Exception());

      final result = await repository.getStudentsEnrollments(studentId, token);

      verify(mockRemoteDataSource.getStudentsEnrollments(studentId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });
  
    /* STUDENT'S EVALUATIONS TESTS */
    test('Should return Right<List<StudentsApprovedSubjectsModel>> when getStudentsEvaluations method is successful', () async {   
      when(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token))
        .thenAnswer((_) async => dummyStdEvsModel);

      final result = await repository.getStudentsEvaluations(studentId, periodId, token);

      verify(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token));

      expect(result.asRight(), equals(dummyStdEvsModel));
    });

    test('Should cache the List<StudentsApprovedSubjectsModel> locally when the getStudentsEvaluations method is successful', () async {     
      when(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token))
        .thenAnswer((_) async => dummyStdEvsModel);

      await repository.getStudentsEvaluations(studentId, periodId, token);

      verify(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token));
      
      verify(mockLocalDataSource.cacheStudentsEvaluations(dummyStdEvsModel));
    });

    test('Should return ServerFailure when getStudentsEvaluations method throws ServerException', () async {     
      when(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token))
        .thenThrow(const ServerException(title: exceptionTitle, message: exceptionMsg));

      final result = await repository.getStudentsEvaluations(studentId, periodId, token);

      verify(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });

    test('Should return ServerFailure when getStudentsEvaluations method throws Exception', () async {     
      when(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token))
        .thenThrow(Exception());

      final result = await repository.getStudentsEvaluations(studentId, periodId, token);

      verify(mockRemoteDataSource.getStudentsEvaluations(studentId, periodId, token));

      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(const Left(ServerFailure(title: failureTitle, cause: failureTitle))));
    });
  });
}