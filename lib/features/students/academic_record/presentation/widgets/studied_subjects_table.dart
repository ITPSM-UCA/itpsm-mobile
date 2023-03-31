import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:itpsm_mobile/domain/data_table_sources/students/academic_record/studied_subjects_data_table_source.dart';
import 'package:itpsm_mobile/core/utils/widgets/data_table/no_data_modal.dart';

class StudiedSubjectsTable extends StatelessWidget {
  const StudiedSubjectsTable({super.key});

  List<DataColumn2> get _columns {
    return const [
      DataColumn2(
        label: Text('Módulo'),
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
      source: StudiedSubjectsAsyncDataTableSource.empty()
    );
  }
}