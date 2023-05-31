import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/constants/constants.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/cubit/students_curricula_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../../core/utils/widgets/horizontal_iconed_text.dart';

class StudentAcademicInformation extends StatefulWidget {
  const StudentAcademicInformation({super.key});

  @override
  State<StudentAcademicInformation> createState() => _StudentAcademicInformationState();
}

class _StudentAcademicInformationState extends State<StudentAcademicInformation> {
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    
    if(_isInit) {
      final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

      if(authUser != null) {
        await context.read<StudentsCurriculaCubit>().loadStudentsCurricula(authUser);
      }

      setState(() { _isInit = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveWrapper.of(context);
    // final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Builder(
            builder: (context) {
              final studentsCurriculaState = context.watch<StudentsCurriculaCubit>().state;

              return studentsCurriculaState.status == RequestStatus.loading ? const CircularProgressIndicator() :
                Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Información académica',
                    //     style: theme.textTheme.titleSmall,
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    // ResponsiveRowColumn(
                    //   rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   rowCrossAxisAlignment: CrossAxisAlignment.start,
                    //   rowSpacing: 20,
                    //   columnMainAxisAlignment: MainAxisAlignment.start,
                    //   columnCrossAxisAlignment: CrossAxisAlignment.center,
                    //   columnSpacing: 20,
                    //   layout: responsive.isSmallerThan(DESKTOP) ? 
                    //   ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                    //   children: [
                    //     ResponsiveRowColumnItem(
                    //       rowFit: FlexFit.tight,
                    //       child: HorizontalIconedText(
                    //         icon: Icons.bookmark,
                    //         text: studentsCurriculaState.studentsCurricula?.cucrriculaName ?? defaultString,
                    //       ),
                    //     ),
                    //     ResponsiveRowColumnItem(
                    //       rowFit: FlexFit.tight,
                    //       child: HorizontalIconedText(
                    //         icon: Icons.event_note,
                    //         text: studentsCurriculaState.studentsCurricula?.entryYear.toString() ?? defaultString
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    ResponsiveRowColumn(
                      rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      rowCrossAxisAlignment: CrossAxisAlignment.start,
                      rowSpacing: 20,
                      columnMainAxisAlignment: MainAxisAlignment.start,
                      columnCrossAxisAlignment: CrossAxisAlignment.center,
                      columnSpacing: 20,
                      layout: responsive.isSmallerThan(DESKTOP) ? 
                      ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                      children: [
                        ResponsiveRowColumnItem(
                          rowFit: FlexFit.tight,
                          child: HorizontalIconedText(
                            icon: Icons.bookmark,
                            iconColor: theme.colorScheme.primary,
                            text: studentsCurriculaState.studentsCurricula?.cucrriculaName ?? defaultString,
                          ),
                        ),
                        // ResponsiveRowColumnItem(
                        //   rowFit: FlexFit.tight,
                        //   child: HorizontalIconedText(
                        //     icon: Icons.event_note,
                        //     text: studentsCurriculaState.studentsCurricula?.entryYear.toString() ?? defaultString
                        //   ),
                        // ),
                        ResponsiveRowColumnItem(
                          rowFit: FlexFit.tight,
                          child: HorizontalIconedText(
                            icon: Icons.scoreboard,
                            iconColor: theme.colorScheme.primary,
                            text: '${studentsCurriculaState.studentsCurricula?.cum.toString() ?? defaultString} (mínimo para egresar: 7.00)',
                          ),
                          // child: VerticalLabeledText(
                          //   label: 'CUM', 
                          //   labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          //   icon: Icons.scoreboard,
                          //   text: '${studentsCurriculaState.studentsCurricula?.cum.toString() ?? defaultString} (mínimo para egresar: 7.00)'
                          // )
                        ),
                        ResponsiveRowColumnItem(
                          rowFit: FlexFit.tight,
                          child: HorizontalIconedText(
                            icon: Icons.assignment_turned_in,
                            iconColor: theme.colorScheme.primary,
                            text: '${studentsCurriculaState.studentsCurricula?.uvTotal?.toString() ?? 0} UV aprobadas'
                          ),
                          // child: VerticalLabeledText(
                          //   label: 'UV aprobadas', 
                          //   icon: Icons.assignment_turned_in,
                          //   labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          //   text: studentsCurriculaState.studentsCurricula?.uv.toString() ?? defaultString
                          // )
                        ),
                      ],
                    ),
                  ],
                );
            }
          ),
        )
      ),
    );
  }
}