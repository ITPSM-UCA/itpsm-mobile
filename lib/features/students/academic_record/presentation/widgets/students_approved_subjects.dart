import 'package:flutter/material.dart';
import 'package:itpsm_mobile/core/utils/widgets/fieldset.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/students_approved_subjects_table.dart';

class StudentsApprovedSubjects extends StatefulWidget {
  const StudentsApprovedSubjects({super.key});

  @override
  State<StudentsApprovedSubjects> createState() => _StudentsApprovedSubjectsState();
}

class _StudentsApprovedSubjectsState extends State<StudentsApprovedSubjects> {
  @override
  Widget build(BuildContext context) {
    return Fieldset(
      title: 'Materias cursadas',
      child: Column(
        children: const [
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 15),
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     'Ciclo 01-2023',
          //     style: theme.textTheme.titleSmall,
          //   )
          // ),
          Expanded(child: StudentsApprovedSubjectsTable())
        ]
      )
    );
  }
}