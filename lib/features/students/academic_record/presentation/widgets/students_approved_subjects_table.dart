import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/widgets/data_table/no_data_modal.dart';
import '../../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../data/data_sources/data_table/students_approved_subjects_data_table_source.dart';
import '../../data/repositories/academic_record_repository_impl.dart';

class StudentsApprovedSubjectsTable extends StatelessWidget {
  const StudentsApprovedSubjectsTable({super.key});

  List<DataColumn2> get _columns {
    return const [
      DataColumn2(
        label: Text('Módulo'),
        // size: ColumnSize.L,
        fixedWidth: 200
      ),
      DataColumn2(
        label: Text('Catedrático'),
      ),
      DataColumn2(
        label: Text('Nota final'),
        numeric: true
      ),
      DataColumn2(
        label: Text('Estado'),
      ),
      DataColumn2(
        label: Text('Matrícula'),
        size: ColumnSize.S,
        numeric: true
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AsyncPaginatedDataTable2(
      columns: _columns, 
      minWidth: 800,
      empty: const NoDataModal(),
      source: StudentsApprovedSubjectsDataTableSource(
        repository: RepositoryProvider.of<AcademicRecordRepositoryImpl>(context),
        authUser: context.read<AuthenticationBloc>().state.authenticatedUser!
      )
    );
  }
}