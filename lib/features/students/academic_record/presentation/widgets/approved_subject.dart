import 'package:flutter/material.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';

class ApprovedSubject extends StatelessWidget {
  final StudentsApprovedSubjectsModel studentsApprovedSubject;

  const ApprovedSubject({super.key, required this.studentsApprovedSubject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isApproved = (studentsApprovedSubject.finalScore ?? 0) > 6;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isApproved ? theme.colorScheme.primary : theme.colorScheme.inversePrimary,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(child: Text(
            studentsApprovedSubject.finalScore?.toStringAsFixed(2) ?? '0',
            style: TextStyle(
              color: isApproved ? Colors.greenAccent : theme.colorScheme.error
            ),
          )),
        ),
      ),
      title: Text(studentsApprovedSubject.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(studentsApprovedSubject.teacherName),
      trailing: Text('${studentsApprovedSubject.uv.toStringAsFixed(0)} UV'),
    );
    // const edges = 10;
    // final theme = Theme.of(context);
    
    // return ConstrainedBox(
    //   constraints: const BoxConstraints(
    //     minWidth: 240,
    //     maxWidth: 425,
    //     minHeight: 300,
    //     maxHeight: 300,
    //   ),
    //   child: Stack(
    //     children: [
    //       ClipRRect(
    //         borderRadius: BorderRadius.circular(10),
    //         child: CustomPaint(
    //           foregroundPainter: TornPageShape(
    //             edges: edges,
    //             primary: theme.colorScheme.primaryContainer,
    //             secondary: theme.colorScheme.surfaceTint,
    //             grade: studentsApprovedSubject.finalScore
    //           ),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //           ),
    //         ),
    //       ),
    //       LayoutBuilder(
    //         builder: (context, constraints) {
    //           return Container(
    //             // Make space for where the dots are
    //             margin: EdgeInsets.only(left: constraints.maxWidth  / edges),
    //             padding: EdgeInsets.only(
    //               left: constraints.maxWidth * 0.025,
    //               // top: constraints.maxHeight * 0.05,
    //               bottom: constraints.maxHeight * 0.05,
    //             ),
    //             // Take all space minus the space where the dots and final score are on the shape
    //             width: (constraints.maxWidth * 0.8) - ((constraints.maxWidth * 0.1) * 2),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 ApprovedSubjectLabel(
    //                   icon: Icons.assignment,
    //                   iconColor: theme.colorScheme.surfaceTint,
    //                   iconSize: (constraints.maxWidth * 0.1) * 0.9,
    //                   label: studentsApprovedSubject.name, 
    //                   fontSize: (constraints.maxWidth * 0.1) * 0.4,
    //                 ),
    //                 ApprovedSubjectLabel(
    //                   icon: Icons.badge,
    //                   iconColor: theme.colorScheme.surfaceTint,
    //                   iconSize: (constraints.maxWidth * 0.1) * 0.9,
    //                   label: studentsApprovedSubject.teacherName, 
    //                   fontSize: (constraints.maxWidth * 0.1) * 0.4,
    //                 ),
    //                 ApprovedSubjectLabel(
    //                   icon: studentsApprovedSubject.isApproved == 1
    //                     ? Icons.verified
    //                     : Icons.new_releases,
    //                   iconColor: theme.colorScheme.surfaceTint,
    //                   iconSize: (constraints.maxWidth * 0.1) * 0.9,
    //                   label: studentsApprovedSubject.isApprovedText,
    //                   fontSize: (constraints.maxWidth * 0.1) * 0.4,
    //                 ),
    //                 ApprovedSubjectLabel(
    //                   icon: Icons.sticky_note_2,
    //                   iconColor: theme.colorScheme.surfaceTint,
    //                   iconSize: (constraints.maxWidth * 0.1) * 0.9,
    //                   label: '${studentsApprovedSubject.enrollment.toStringAsFixed(0)} UV', 
    //                   fontSize: (constraints.maxWidth * 0.1) * 0.4,
    //                 ),
    //               ],
    //             ),
    //           );
    //         }
    //       )
    //     ],
    //   ),
    // );
  }
}