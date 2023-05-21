import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../data/models/students_evaluations_model.dart';
import 'evaluation_tile.dart';

class SubjectsEvauations extends StatelessWidget {
  final String subjectName;
  final List<StudentsEvaluationsModel> evaluations;

  const SubjectsEvauations({super.key, required this.subjectName, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpandablePanel(
      header: Container(
        padding: const EdgeInsets.all(5),
        child: Text(
          subjectName, 
          style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.primary
        )),
      ),
      collapsed: const SizedBox(),
      expanded: Column(
        children: evaluations.map((evaluation) {
          return EvaluationTile(evaluation: evaluation);
        }).toList(),
      )
    );
  }
}