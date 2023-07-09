import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';

class EvaluationTile extends StatelessWidget {
  final bool isSubevaluation;
  final StudentsEvaluationsModel evaluation;
  
  const EvaluationTile({super.key, required this.evaluation, this.isSubevaluation = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isApproved = (evaluation.evaluationScore ?? 0) > 6;
    final hasSubevaluations = evaluation.subevaluations != null && evaluation.subevaluations!.isNotEmpty;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: isSubevaluation ? isApproved ? theme.colorScheme.secondary : theme.colorScheme.secondaryContainer
            : isApproved ? theme.colorScheme.primary : theme.colorScheme.inversePrimary,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(child: Text(
                evaluation.evaluationScore?.toStringAsFixed(2) ?? "0",
                style: TextStyle(
                  color: isApproved ?  Colors.lightGreenAccent : theme.colorScheme.error
                  // : theme.colorScheme.copyWith(error: Colors.redAccent).error
                ),
              )),
            ),
          ),
          title: Text(evaluation.name, overflow: TextOverflow.ellipsis,),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(evaluation.date)),
          trailing: Text('${evaluation.percentage.toStringAsFixed(1)}%'),
        ),
        hasSubevaluations ? 
        ExpandableNotifier(
          child: Expandable(
            collapsed: Center(
              child: ExpandableButton(
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  ...evaluation.subevaluations!.map((sub) {
                    return EvaluationTile(evaluation: sub, isSubevaluation: true);
                  }).toList(),
                  ExpandableButton(
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                ],
              ),
            ),
          )
        )
        : const SizedBox()
      ],
    );
  }
}