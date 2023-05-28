import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/features/appbar/presentation/main_app_bar.dart';
import 'package:itpsm_mobile/features/drawer/presentation/main_drawer_screen.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_local_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/data_sources/academic_record_remote_data_source.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/repositories/academic_record_repository_impl.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/cubit/students_curricula_cubit.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/student_academic_information.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/widgets/students_approved_subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/widgets/horizontal_iconed_text.dart';
import '../../../../authentication/data/models/authenticated_user_model.dart';
import '../../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../cubit/students_approved_subjects_cubit.dart';

class AcademicRecordScreen extends StatelessWidget {
  static const routeName = '/dashboard/historial-academico';
  
  const AcademicRecordScreen({super.key});

  Future<void> _refreshAcademicRecordScreen(BuildContext context, AuthenticatedUserModel authUser) async {
    await context.read<StudentsCurriculaCubit>().loadStudentsCurricula(authUser);
                          
    if(context.mounted) {
      await context.read<StudentsApprovedSubjectsCubit>().loadStudentsApprovedSubjects(authUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.read<AuthenticationBloc>();
    final authUser = authProvider.state.authenticatedUser;
  
    return Scaffold(
      appBar: MainAppBar(appBarTitle: Text('Historial Académico', style: TextStyle(color: theme.colorScheme.primary))),
      drawer: const MainDrawerScreen(),
      body: SizedBox.expand(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null) {
              return RepositoryProvider(
                create: (context) => AcademicRecordRepositoryImpl(
                  network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
                  localDataSource: AcademicRecordLocalDataSourceImpl(sharedPreferences: snapshot.data!),
                  remoteDataSource: AcademicRecordRemoteDataSourceImpl(client: http.Client())
                ),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<StudentsCurriculaCubit>(
                      create: (context) => StudentsCurriculaCubit(repository: context.read<AcademicRecordRepositoryImpl>())
                    ),
                    BlocProvider<StudentsApprovedSubjectsCubit>(
                      create: (context) => StudentsApprovedSubjectsCubit(repository: context.read<AcademicRecordRepositoryImpl>())
                    )
                  ],
                  child: Builder(
                    builder: (context) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          if(authUser != null) {
                            await _refreshAcademicRecordScreen(context, authUser);
                          }
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(10),
                                child: HorizontalIconedText(
                                  icon: Icons.school,
                                  iconColor: theme.colorScheme.primary,
                                  text: authUser?.name ?? defaultString,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                // child: Text(
                                //   authUser?.name ?? defaultString,
                                //   style: Theme.of(context).textTheme.titleMedium,
                                // ),
                              ),
                              const StudentAcademicInformation(),
                              const StudentsApprovedSubjects()
                              // ConstrainedBox(
                              //   constraints: const BoxConstraints.expand(
                              //     width: double.infinity,
                              //     height: 500
                              //   ),
                              //   child: const StudentsApprovedSubjects(),
                              // )
                            ],
                          ),
                        ),
                      );
                    }
                  )
                )
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}