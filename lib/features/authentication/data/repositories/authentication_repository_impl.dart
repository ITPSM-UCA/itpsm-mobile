import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/exceptions/http/server_exception.dart';
import 'package:itpsm_mobile/core/errors/failures/cache/cache_failure.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:logger/logger.dart';

import '../../domain/repositories/authentication_repository.dart';
import '../data_sources/login_local_data_source.dart';
import '../data_sources/login_remote_data_source.dart';
import '../models/authenticated_user_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  static final Logger logger = getLogger();

  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;
  final NetworkInfo network;

  const AuthenticationRepositoryImpl({
    required this.remoteDataSource, 
    required this.localDataSource, 
    required this.network
  });
  
  @override
  Future<Either<Failure, AuthenticatedUserModel>> login(String email, String password) async {
    if(await network.isConnected) {
      try {  
        final remoteUser = await remoteDataSource.login(email, password);

        localDataSource.cacheLoginSession(remoteUser);
        return Right(remoteUser);
      } on ServerException catch (e) {
        logger.e('User login failed.', e);
        return const Left(ServerFailure());
      }
    }
    else {
      try {
        final lastLoginSession = await localDataSource.getLastLoginSession();
        
        return Right(lastLoginSession);
      } catch (e) {
        logger.e('Login cache was not present.', e);
        return Left(CacheFailure());
      }
      // return Left(CacheFailure());
    }
  }
}