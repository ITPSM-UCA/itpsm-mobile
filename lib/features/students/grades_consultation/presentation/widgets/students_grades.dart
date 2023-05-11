import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/students_grades_table.dart';

import '../../../../../core/utils/widgets/fieldset.dart';
import '../../data/models/students_evaluations_model.dart';
import '../cubit/students_evaluation_cubit.dart';
import '../cubit/students_evaluation_state.dart';

class StudentsGrades extends StatefulWidget {
  const StudentsGrades({super.key});

  @override
  State<StudentsGrades> createState() => _StudentsGradesState();
}

class _StudentsGradesState extends State<StudentsGrades> {
  List<StudentsEvaluationsModel> _evaluations = [];

  Map<String, List<StudentsEvaluationsModel>> _groupEvaluationsBySubjectName(List<StudentsEvaluationsModel> evaluations) {
    return groupBy(evaluations, (evaluation) => evaluation.subjectName);
  }

  List<StudentsGradesTable> _buildStudentsGradesTable(List<StudentsEvaluationsModel> evaluations) {
    List<StudentsGradesTable> grades = [];
    Map<String, List<StudentsEvaluationsModel>> groupedGrades = _groupEvaluationsBySubjectName(evaluations);
    
    groupedGrades.forEach((key, value) {
      grades.add(StudentsGradesTable(subjectName: key, evaluations: value));
    });

    return grades;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsEvaluationsCubit, StudentsEvaluationsState>(
      listener: (context, state) {
        if(state.status == RequestStatus.loaded && state.evaluations != null && state.evaluations!.isNotEmpty) {
          setState(() { _evaluations = [...state.evaluations!]; });
        }
      },
      child: _evaluations.isEmpty ? const Center(child: Text('Seleccione un ciclo'))
      : Fieldset(
        title: '',
        child: SingleChildScrollView(
          child: BlocListener<StudentsEvaluationsCubit, StudentsEvaluationsState>(
            listener: (context, state) {
              if(state.status == RequestStatus.loaded && state.evaluations != null && state.evaluations!.isNotEmpty) {
                setState(() { _evaluations = [...state.evaluations!]; });
              }
            },
            child: Column(
              children: _buildStudentsGradesTable(_evaluations)
            )
          )
        ),
      )
    );
  }
}