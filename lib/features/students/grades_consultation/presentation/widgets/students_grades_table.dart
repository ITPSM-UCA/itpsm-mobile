import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';

class StudentsGradesTable extends StatelessWidget {
  final String subjectName;
  final List<StudentsEvaluationsModel> evaluations;

  const StudentsGradesTable({super.key, required this.subjectName, required this.evaluations});

  List<DataColumn2> get _columns {
    return const [
      DataColumn2(
        label: Text('Evaluación'),
        size: ColumnSize.L
      ),
      // DataColumn2(
      //   label: Text('Subevaluación'),
      //   size: ColumnSize.L
      // ),
      DataColumn2(
        label: Text('Fecha'),
      ),
      DataColumn2(
        label: Text('Porcentaje'),
        numeric: true
      ),
      DataColumn2(
        label: Text('Nota'),
        numeric: true
      ),
    ];
  }

  List<StudentsEvaluationsModel> _includeSubevaluations(List<StudentsEvaluationsModel> evaluations) {
    List<StudentsEvaluationsModel> all = [];

    for (var evaluation in evaluations) {
      all.add(evaluation);

      if(evaluation.subevaluations != null && evaluation.subevaluations!.isNotEmpty) {
        all.addAll(evaluation.subevaluations!);
      }
    }

    return all;
  }

  List<DataRow> _buildStudentsGradesTableRows(List<StudentsEvaluationsModel> evaluations) {
    return _includeSubevaluations(evaluations).map((evaluation) {
      final DataCell nameHeader = evaluation.principalId != null ? 
        DataCell(Padding(
          padding: const EdgeInsets.all(15),
          child: Text(evaluation.name),
        )) : DataCell(Text(evaluation.name));
      
      return DataRow2(
        cells: [
          nameHeader,
          DataCell(Text(DateFormat('dd/MM/yyyy').format(evaluation.date))),
          DataCell(Text(evaluation.percentage.toString())),
          DataCell(Text(evaluation.evaluationScore?.toStringAsFixed(2) ?? "0")),
        ]
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            subjectName,
            style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary)
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.expand(
            width: double.infinity,
            height: 400
          ),
          child: Card(
            child: DataTable2(
              decoration: const BoxDecoration(),
              showBottomBorder: true,
              columns: _columns,
              rows: _buildStudentsGradesTableRows(evaluations)
            ),
          ),
        )
      ],
    );
  }
}