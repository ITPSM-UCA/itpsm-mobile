import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:itpsm_mobile/core/utils/extensions/either_extensions.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/domain/repositories/academic_record_repository.dart';
import 'package:logger/logger.dart';

class StudentsApprovedSubjectsDataTableSource extends AsyncDataTableSource {
  static final Logger logger = getLogger();
  
  final AcademicRecordRepository repository;
  final AuthenticatedUserModel authUser;

  StudentsApprovedSubjectsDataTableSource({required this.repository, required this.authUser});
  
  // bool _empty = false;
  // int? _errorCounter;

  // StudentsApprovedSubjectsDataTableSource.empty() {
  //   _empty = true;
  // }

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    logger.d('getRows($start, $end)');

    assert(start >= 0);
    
    final result = await repository.getStudentsApprovedSubjects(authUser.systemReferenceId, authUser.token);

    if(result.isRight()) {
      return AsyncRowsResponse(
        result.asRight()?.length ?? 0, 
        result.asRight()?.map((subject) {
          return DataRow(cells: [
            DataCell(Text(subject.name)),
            DataCell(Text(subject.teacherName)),
            DataCell(Text(subject.finalScore.toStringAsFixed(1))),
            DataCell(Text(subject.isApprovedText)),
            DataCell(Text(subject.enrollment.toString()))
          ]);
        }).toList() ?? []
      );
    }
    else {
      return AsyncRowsResponse(0, []);
    }
  }
}