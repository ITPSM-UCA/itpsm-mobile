import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/approved_subject.dart';

class ApprovedSubjectsByYear extends StatelessWidget {
  final int year;
  final List<ApprovedSubject> approvedSubjects;

  const ApprovedSubjectsByYear({super.key, required this.year, required this.approvedSubjects});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpandablePanel(
      header: Container(
        padding: const EdgeInsets.all(5),
        child: Text(
          year.toString(), 
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.primary
          )
        ),
      ),
      collapsed: const SizedBox(),
      expanded: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: approvedSubjects.map((subject) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: subject,
          );
        }).toList(),
      ),
    );
  }
}