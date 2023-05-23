import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/exceptions/cache/cache_exception.dart';
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/cache/cache_failure.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_local_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_remote_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:logger/logger.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../../domain/repositories/academic_record_repository.dart';
import '../models/students_curricula_model.dart';

class AcademicRecordRepositoryImpl extends AcademicRecordRepository {
  static final Logger logger = getLogger();
  
  final NetworkInfo network;
  final AcademicRecordLocalDataSource localDataSource;
  final AcademicRecordRemoteDataSource remoteDataSource;

  AcademicRecordRepositoryImpl({
    required this.network, 
    required this.localDataSource, 
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, StudentsCurriculaModel>> getStudentsCurricula(int studentId, String token) async {
    if(await network.isConnected) {
      try {  
        final studentsCurricula = await remoteDataSource.getStudentsCurricula(studentId, token);

        localDataSource.cacheStudentsCurricula(studentsCurricula);
        return Right(studentsCurricula);
      } on ServerException catch(e) {
        logger.e('Server failure when trying to get student $studentId curricula.', e);
        return Left(ServerFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to get student $studentId curricula. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
    else {
      try {
        final studentsCurriculaLocalCopy = await localDataSource.getLastStudentsCurricula();

        return Right(studentsCurriculaLocalCopy);
      } on CacheException catch (e) {
        logger.e('Cache failure when trying to retrieve local copy of student $studentId curricula.', e);
        return Left(CacheFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to retrieve local copy of $studentId curricula. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
  }

  @override
  Future<Either<Failure, List<StudentsApprovedSubjectsModel>>> getStudentsApprovedSubjects(int studentId, String token) async {
    if(await network.isConnected) {
      try {  
        final studentsApprovedSubjects = await remoteDataSource.getStudentsApprovedSubjects(studentId, token);

        localDataSource.cacheStudentsApprovedSubjects(studentsApprovedSubjects);
        return Right(studentsApprovedSubjects);
      } on ServerException catch(e) {
        logger.e('Server failure when trying to get student $studentId approved subjects.', e);
        return Left(ServerFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to get student $studentId approved subjects. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
    else {
      try {
        final studentsApprovedSubjectsLocalCopy = await localDataSource.getLastStudentsApprovedSubjects();

        return Right(studentsApprovedSubjectsLocalCopy);
      } on CacheException catch (e) {
        logger.e('Cache failure when trying to retrieve local copy of student $studentId approved subjects.', e);
        return Left(CacheFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to retrieve local copy of student $studentId approved subjects. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
  }

}