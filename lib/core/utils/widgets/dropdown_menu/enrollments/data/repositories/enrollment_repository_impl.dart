import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/data_sources/enrollment_local_data_source.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/data_sources/enrollment_remote_data_source.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/models/enrollment_model.dart';
import 'package:logger/logger.dart';

import '../../../../../../errors/exceptions/cache/cache_exception.dart';
import '../../../../../../errors/exceptions/http/server_exception.dart';
import '../../../../../../errors/failures/cache/cache_failure.dart';
import '../../../../../../errors/failures/http/server_failure.dart';
import '../../../../../log/get_logger.dart';
import '../../domain/repositories/enrollment_repository.dart';

class EnrollmentRepositoryImpl extends EnrollmentRepository {
  static final Logger logger = getLogger();
  
  final EnrollmentRemoteDataSource remoteDataSource;
  final EnrollmentLocalDataSource localDataSource;
  final NetworkInfo network;

  EnrollmentRepositoryImpl({
    required this.remoteDataSource, 
    required this.localDataSource, 
    required this.network
  });

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
}