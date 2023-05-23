import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/globals/request_status.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/models/enrollment_model.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/presentation/cubit/enrollment_cubit.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/presentation/cubit/enrollment_state.dart';
import 'package:logger/logger.dart';

import '../../../../../../features/authentication/presentation/bloc/authentication_bloc.dart';
import '../../../../../../features/students/grades_consultation/presentation/cubit/students_evaluation_cubit.dart';

class EnrollmentsDrowdownMenu extends StatefulWidget {
  const EnrollmentsDrowdownMenu({super.key});

  @override
  State<EnrollmentsDrowdownMenu> createState() => _EnrollmentsDrowdownMenuState();
}

class _EnrollmentsDrowdownMenuState extends State<EnrollmentsDrowdownMenu> {
  static final Logger logger = getLogger();

  bool _isInit = true;
  bool _doFirstEvaluationsLoad = true;
  late EnrollmentModel? _selectedValue;
  List<EnrollmentModel> _enrollments = [];

  void _dropdownCallback(EnrollmentModel? selectedValue) async {
    logger.d('Selected Enrollment ${selectedValue?.toJson()}');
    
    final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

    if(selectedValue != null) {
      context.read<EnrollmentCubit>().selectEnrollment(selectedValue);
      
      setState(() { _selectedValue = selectedValue; });

      if(authUser != null) {
        await context.read<StudentsEvaluationsCubit>().loadStudentsEvaluations(authUser, selectedValue.id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedValue = _enrollments.isEmpty ? null : _enrollments[0];
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    
    if(_isInit) {
      final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

      if(authUser != null) {
        await context.read<EnrollmentCubit>().loadEnrollments(authUser);
      }

      setState(() { _isInit = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<EnrollmentCubit, EnrollmentState>(
      listener: (context, state) {
        // TODO: Fix setting state whenever a new enrollment is selected. Perhaps using Bloc instead of cubit will be necessary
        if(state.status == RequestStatus.loaded && state.enrollments != null && state.enrollments!.isNotEmpty) {
          setState(() {
            _enrollments = [...state.enrollments!];

            if(_doFirstEvaluationsLoad) {
              _selectedValue = _enrollments[0];
              
              final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

              if(authUser != null) {
                context.read<StudentsEvaluationsCubit>().loadStudentsEvaluations(authUser, _selectedValue!.id);
              }

              _doFirstEvaluationsLoad = false;
            }
          });
        }
      },
      child: DropdownButton(
        isExpanded: true,
        value: _selectedValue,
        hint: const Text('Selecciona un ciclo'),
        disabledHint: const Text('Ciclos no disponibles'),
        iconEnabledColor: theme.colorScheme.primary,
        iconDisabledColor: theme.colorScheme.primary,
        style: TextStyle(
          color: theme.colorScheme.primary
        ),
        underline: Container(
          height: 2,
          color: theme.colorScheme.primary,
        ),
        items: _enrollments.map((enrollment) {
          return DropdownMenuItem<EnrollmentModel>(
            value: enrollment,
            child: Text(enrollment.periodText),
          );
        }).toList(),
        onChanged: _enrollments.isEmpty ? null : _dropdownCallback,

      ),
    );
  }
}