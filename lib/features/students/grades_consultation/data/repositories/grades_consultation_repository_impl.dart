import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_local_data_source.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/data_sources/grades_consultation_data_source.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/enrollment_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:collection/collection.dart';

import '../../../../../core/errors/exceptions/cache/cache_exception.dart';
import '../../../../../core/errors/exceptions/http/server_exception.dart';
import '../../../../../core/errors/failures/cache/cache_failure.dart';
import '../../../../../core/errors/failures/http/server_failure.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../../domain/repositories/grades_consultation_repository.dart';

class GradesConsultationRepositoryImpl extends GradesConsultationRepository {
  static final Logger logger = getLogger();

  final GradesConsultationRemoteDataSource remoteDataSource;
  final GradesConsultationLocalDataSource localDataSource;
  final NetworkInfo network;

  GradesConsultationRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.network});

  @override
  Future<Either<Failure, List<EnrollmentModel>>> getStudentsEnrollments(int studentId, String token) async {
    if(await network.isConnected) {
      try {  
        final studentsEnrollments = await remoteDataSource.getStudentsEnrollments(studentId, token);

        localDataSource.cacheStudentsEnrollments(studentsEnrollments);
        return Right(studentsEnrollments);
      } on ServerException catch(e) {
        logger.e('Server failure when trying to get student $studentId enrollments.', e);
        return Left(ServerFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to get student $studentId enrollments. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
    else {
      try {
        final studentsEnrollments = await localDataSource.getLastStudentsEnrollments();

        return Right(studentsEnrollments);
      } on CacheException catch (e) {
        logger.e('Cache failure when trying to retrieve local copy of student $studentId enrollments.', e);
        return Left(CacheFailure(title: e.title, cause: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<StudentsEvaluationsModel>>> getStudentsEvaluations(int studentId, int periodId, String token) async {
    if(await network.isConnected) {
      try {  
        final studentsEvaluations = _linkSubevaluations(await remoteDataSource.getStudentsEvaluations(studentId, periodId, token));

        localDataSource.cacheStudentsEvaluations(studentsEvaluations);
        return Right(studentsEvaluations);
      } on ServerException catch(e) {
        logger.e('Server failure when trying to get student $studentId enrollments.', e);
        return Left(ServerFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Failure when trying to get student $studentId enrollments. Reason unknown.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
    else {
      try {
        final studentsEvaluations = await localDataSource.getLastStudentsEvaluations();

        return Right(studentsEvaluations);
      } on CacheException catch (e) {
        logger.e('Cache failure when trying to retrieve local copy of student $studentId evaluations.', e);
        return Left(CacheFailure(title: e.title, cause: e.message));
      }
    }
  }

  List<StudentsEvaluationsModel> _linkSubevaluations(List<StudentsEvaluationsModel> evaluations) {
    List<StudentsEvaluationsModel> all = [];
    Map<int, List<StudentsEvaluationsModel>> evaluationsById = groupBy(evaluations, (evaluation) => evaluation.id);
    Map<int, List<StudentsEvaluationsModel>> evaluationsByParent = groupBy(evaluations, (evaluation) => evaluation.principalId ?? 0);

    evaluationsById.forEach((key, value) { 
      if(evaluationsByParent[key] != null) {
        all.add(value[0].copyWith(subevaluations: evaluationsByParent[key]));
      }
      else if(value[0].principalId == null) {
        all.add(value[0].copyWith());
      }
    });

    return all;
  }
}