import 'package:dartz/dartz.dart';
import 'package:itpsm_mobile/core/errors/failures/failure.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_local_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_remote_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/entities/students_approved_subjects.dart';

import '../../../../../core/network/network_info.dart';
import '../../domain/repositories/academic_record_repository.dart';
import '../models/students_curricula_model.dart';

class AcademicRecordRepositoryImpl extends AcademicRecordRepository {
  final NetworkInfo network;
  final AcademicRecordLocalDataSource localDataSource;
  final AcademicRecordRemoteDataSource remoteDataSource;

  AcademicRecordRepositoryImpl({
    required this.network, 
    required this.localDataSource, 
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, StudentsCurriculaModel>> getStudentsCurricula(int studentId) {
    // TODO: implement getStudentCurricula
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<StudentsApprovedSubjects>>> getStudentsApprovedSubjects() {
    // TODO: implement getStudentsApprovedSubjects
    throw UnimplementedError();
  }

}