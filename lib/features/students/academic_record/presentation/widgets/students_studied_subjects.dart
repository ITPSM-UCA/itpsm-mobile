import 'package:flutter/material.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/studied_subjects_table.dart';
import 'package:itpsm_mobile/core/utils/widgets/fieldset.dart';

class StudentsStudiedSubjects extends StatelessWidget {
  const StudentsStudiedSubjects({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Fieldset(
      title: 'Materias cursadas',
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Ciclo 01-2023',
              style: theme.textTheme.titleSmall,
            )
          ),
          const Expanded(child: StudiedSubjectsTable())
        ]
      )
    );
  }
}