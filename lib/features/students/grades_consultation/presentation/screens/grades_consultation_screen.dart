import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/data_sources/enrollment_local_data_source.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/data_sources/enrollment_remote_data_source.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/data/repositories/enrollment_repository_impl.dart';
import 'package:itpsm_mobile/core/utils/widgets/dropdown_menu/enrollments/presentation/cubit/enrollment_cubit.dart';
import 'package:itpsm_mobile/features/appbar/presentation/main_app_bar.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:itpsm_mobile/features/drawer/presentation/main_drawer_screen.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/repositories/students_evaluations_repository_impl.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/students_grades.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../core/utils/widgets/dropdown_menu/enrollments/presentation/enrollments_dropdown_menu.dart';
import '../../data/data_sources/students_evaluations_local_data_source.dart';
import '../../data/data_sources/students_evaluations_remote_data_source.dart';
import '../cubit/students_evaluation_cubit.dart';

class GradesConsultationScreen extends StatelessWidget {
  static const routeName = '/dashboard/notas';

  final String title = '';

  const GradesConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

    return Scaffold(
      appBar: const MainAppBar(appBarTitle: 'Ver Notas'),
      drawer: const MainDrawerScreen(),
      body: SizedBox.expand(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null) {
                return MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                      create: (context) => EnrollmentRepositoryImpl(
                        network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
                        localDataSource: EnrollmentLocalDataSourceImpl(sharedPreferences: snapshot.data!),
                        remoteDataSource: EnrollmentRemoteDataSourceImpl(client: http.Client())
                      )
                    ),
                    RepositoryProvider(
                      create: (context) => StudentsEvaluationsRepositoryImpl(
                        network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
                        localDataSource: StudentsEvaluationsLocalDataSourceImpl(sharedPreferences: snapshot.data!),
                        remoteDataSource: StudentsEvaluationsRemoteDataSourceImpl(client: http.Client())
                      )
                    ),
                  ],
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<EnrollmentCubit>(
                        create: (context) => EnrollmentCubit(repository: context.read<EnrollmentRepositoryImpl>()),
                      ),
                      BlocProvider<StudentsEvaluationsCubit>(
                        create: (context) => StudentsEvaluationsCubit(repository: context.read<StudentsEvaluationsRepositoryImpl>()),
                      ),
                    ],
                    child: Builder(
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 240,
                                    maxWidth: 300,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: EnrollmentsDrowdownMenu(),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final selectedEnrollment = context.read<EnrollmentCubit>().state.selectedEnrollment;
                                            if(selectedEnrollment != null) {
                                              if(authUser != null) {
                                                await context.read<StudentsEvaluationsCubit>().loadStudentsEvaluations(authUser, selectedEnrollment.id);
                                              }
                                            }
                                            else {
                                              ScaffoldMessengerState snackbar = ScaffoldMessenger.of(context);

                                              snackbar.hideCurrentSnackBar();
                                              snackbar.showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text('Se debe seleccionar un ciclo.'),
                                                dismissDirection: DismissDirection.endToStart,
                                              ));
                                            }
                                          },
                                          child: const Text('Filtrar')
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const StudentsGrades()
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