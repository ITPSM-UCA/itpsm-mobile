import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/connection/connection_failure.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/core/errors/failures/http/server_failure.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions/authentication/authentication_exception.dart';
import '../../../../core/errors/failures/authentication/authentication_failure.dart';
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
      } on AuthenticationException catch(e) {
        logger.e('Authentication failure when trying to login.', e);
        return Left(AuthenticationFailure(title: e.title, cause: e.message));
      } catch(e) {
        logger.e('Server failure when trying to login.', e);
        return const Left(ServerFailure(title: 'Error', cause: 'Something went wrong...'));
      }
    }
    else {
      return Left(ConnectionFailure.defaultConnectionFailure());
    }
  }
}