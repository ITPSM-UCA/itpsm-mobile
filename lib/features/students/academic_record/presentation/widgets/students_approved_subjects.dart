import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/widgets/fieldset.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/approved_subjects_by_year.dart';

import '../../../../../core/utils/globals/request_status.dart';
import '../../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../cubit/students_approved_subjects_cubit.dart';
import '../cubit/students_approved_subjects_state.dart';
import 'approved_subject.dart';

class StudentsApprovedSubjects extends StatefulWidget {
  const StudentsApprovedSubjects({super.key});

  @override
  State<StudentsApprovedSubjects> createState() => _StudentsApprovedSubjectsState();
}

class _StudentsApprovedSubjectsState extends State<StudentsApprovedSubjects> {
  bool _isInit = true;
  Widget _approvedSubjectsView = const SizedBox();
  List<StudentsApprovedSubjectsModel> _approvedSubjects = [];
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    
    if(_isInit) {
      final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

      if(authUser != null) {
        await context.read<StudentsApprovedSubjectsCubit>().loadStudentsApprovedSubjects(authUser);
      }

      setState(() { _isInit = false; });
    }
  }

  Map<int, List<ApprovedSubject>> _groupApprovedSubjectsByPeriod(List<StudentsApprovedSubjectsModel> approvedSubject) {
    return groupBy(approvedSubject.map((subject) {
      return ApprovedSubject(studentsApprovedSubject: subject);
    }).toList(), (subject) => subject.studentsApprovedSubject.periodYear);
  }

  List<Widget> _getApprovedSubjectsByYear(List<StudentsApprovedSubjectsModel> approvedSubject) {
    final List<Widget> subjectsByYear = [];
    final subjects = _groupApprovedSubjectsByPeriod(approvedSubject);

    subjects.forEach((key, value) {
      subjectsByYear.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ApprovedSubjectsByYear(year: key,approvedSubjects: value,)
        )
      );
    });

    return subjectsByYear;
  }

  void _buildApprovedSubjectsView(StudentsApprovedSubjectsState state) {
    if(state.status == RequestStatus.initial || state.status == RequestStatus.loading) {
      _approvedSubjectsView = const CircularProgressIndicator();
    }
    else if(state.status == RequestStatus.failure 
      || (state.status == RequestStatus.loaded && state.subjects != null && state.subjects!.isEmpty)) {
      _approvedSubjectsView = const Center(child: Text('No se encontraron datos...'));
    }
    else {
      _approvedSubjects = [...state.subjects!];
      _approvedSubjectsView = Fieldset(
        child: Column(
          children: _getApprovedSubjectsByYear(_approvedSubjects),
        ),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsApprovedSubjectsCubit, StudentsApprovedSubjectsState>(
      listener: (context, state) {
        // if(state.status == RequestStatus.loaded && state.subjects != null && state.subjects!.isNotEmpty) {
        //   setState(() { _approvedSubjects = [...state.subjects!]; });
        // }
        setState(() { _buildApprovedSubjectsView(state); });
      },
      child: _approvedSubjectsView
    );
  }
}