import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/core/utils/widgets/fieldset.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/subjects_evaluations.dart';

import '../../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../data/models/students_evaluations_model.dart';
import '../cubit/enrollment/enrollment_cubit.dart';
import '../cubit/students_evaluations/students_evaluation_cubit.dart';
import '../cubit/students_evaluations/students_evaluation_state.dart';

class StudentsGrades extends StatefulWidget {
  const StudentsGrades({super.key});

  @override
  State<StudentsGrades> createState() => _StudentsGradesState();
}

class _StudentsGradesState extends State<StudentsGrades> {
  List<StudentsEvaluationsModel> _evaluations = [];
  Widget _subjectsEvaluationsView = const SizedBox();

  Map<String, List<StudentsEvaluationsModel>> _groupEvaluationsBySubjectName(List<StudentsEvaluationsModel> evaluations) {
    return groupBy(evaluations, (evaluation) => evaluation.subjectName);
  }

  void _buildSubjectsEvaluationsView(StudentsEvaluationsState state) {
    if(state.status == RequestStatus.initial || state.status == RequestStatus.loading) {
      _subjectsEvaluationsView = const Center(child: CircularProgressIndicator());
    }
    else if(state.status == RequestStatus.failure || (state.status == RequestStatus.loaded && state.evaluations != null && state.evaluations!.isEmpty)) {
      _subjectsEvaluationsView = const Center(child: Text('No se encontraron datos...'));
    }
    else {
      _evaluations = [...state.evaluations!];
      _subjectsEvaluationsView = SingleChildScrollView(
        child: Column(children: _buildSubjectsEvaluations(_evaluations, context))
      );
    }
  }

  List<Widget> _buildSubjectsEvaluations(List<StudentsEvaluationsModel> evaluations, BuildContext context) {
    List<Widget> grades = [];
    final theme = Theme.of(context);
    Map<String, List<StudentsEvaluationsModel>> groupedGrades = _groupEvaluationsBySubjectName(evaluations);
    
    groupedGrades.forEach((key, value) {
      grades.add(
        Fieldset(
          child: Column(
            children: [
              SubjectsEvauations(subjectName: key, evaluations: value),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nota Total',
                      style: theme.textTheme.titleSmall!.copyWith(
                        color: theme.colorScheme.primary
                      )
                    ),
                    Text(
                      value[0].subjectFinalScore?.toStringAsFixed(2) ?? "0",
                      style: theme.textTheme.titleSmall
                    )
                  ],
                ),
              )
            ],
          ),
        )
      );
    });

    return grades;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsEvaluationsCubit, StudentsEvaluationsState>(
      listener: (context, state) {
        // if(state.status == RequestStatus.loaded && state.evaluations != null && state.evaluations!.isNotEmpty) {
        //   setState(() { _evaluations = [...state.evaluations!]; });
        // }
        setState(() { _buildSubjectsEvaluationsView(state); });
      },
      child: RefreshIndicator(
        onRefresh: () async {
          final authUser =context.read<AuthenticationBloc>().state.authenticatedUser;
          final selectedEnrollment = context.read<EnrollmentCubit>().state.selectedEnrollment;

          if(selectedEnrollment != null && authUser != null) {
            await context.read<StudentsEvaluationsCubit>().loadStudentsEvaluations(authUser, selectedEnrollment.id);
          }
        },
        child: _subjectsEvaluationsView
      )
    );
  }
}