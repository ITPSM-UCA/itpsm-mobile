import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/features/appbar/presentation/main_app_bar.dart';
import 'package:itpsm_mobile/features/drawer/presentation/main_drawer_screen.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/widgets/students_grades.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/network_info.dart';
import '../../data/data_sources/grades_consultation_data_source.dart';
import '../../data/data_sources/grades_consultation_local_data_source.dart';
import '../../data/repositories/grades_consultation_repository_impl.dart';
import '../cubit/enrollment/enrollment_cubit.dart';
import '../cubit/students_evaluations/students_evaluation_cubit.dart';
import '../widgets/enrollments_dropdown_menu.dart';

class GradesConsultationScreen extends StatelessWidget {
  static const routeName = 'dashboard/notas';

  const GradesConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final authUser = context.read<AuthenticationBloc>().state.authenticatedUser;

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
            return MultiRepositoryProvider(
              providers: [
                // RepositoryProvider(
                //   create: (context) => EnrollmentRepositoryImpl(
                //     network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
                //     localDataSource: EnrollmentLocalDataSourceImpl(sharedPreferences: snapshot.data!),
                //     remoteDataSource: EnrollmentRemoteDataSourceImpl(client: http.Client())
                //   )
                // ),
                RepositoryProvider(
                  create: (context) => GradesConsultationRepositoryImpl(
                    network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
                    localDataSource: GradesConsultationLocalDataSourceImpl(sharedPreferences: snapshot.data!),
                    remoteDataSource: GradesConsultationRemoteDataSourceImpl(client: http.Client())
                  )
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<EnrollmentCubit>(
                    create: (context) => EnrollmentCubit(repository: context.read<GradesConsultationRepositoryImpl>()),
                  ),
                  BlocProvider<StudentsEvaluationsCubit>(
                    create: (context) => StudentsEvaluationsCubit(repository: context.read<GradesConsultationRepositoryImpl>()),
                  ),
                ],
                child: Builder(
                  builder: (context) {
                    return Scaffold(
                      appBar: MainAppBar(
                        appBarTitle: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 150,
                            maxWidth: 150,
                          ),
                          child: const EnrollmentsDrowdownMenu()
                        )
                      ),
                      drawer: const MainDrawerScreen(),
                      body: const SizedBox.expand(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: StudentsGrades()
                          // child: Column(
                          //   children: [
                          //     ConstrainedBox(
                          //       constraints: const BoxConstraints(
                          //         minWidth: 240,
                          //         maxWidth: 300,
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Expanded(child: Padding(
                          //             padding: EdgeInsets.all(8),
                          //             child: EnrollmentsDrowdownMenu(),
                          //           )),
                          //           Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: ElevatedButton(
                          //               onPressed: () async {
                          //                 final selectedEnrollment = context.read<EnrollmentCubit>().state.selectedEnrollment;
                                            
                          //                 if(selectedEnrollment != null && authUser != null) {
                          //                   await context.read<StudentsEvaluationsCubit>().loadStudentsEvaluations(authUser, selectedEnrollment.id);
                          //                 }
                          //                 else {
                          //                   ScaffoldMessengerState snackbar = ScaffoldMessenger.of(context);
                                            
                          //                   snackbar.hideCurrentSnackBar();
                          //                   snackbar.showSnackBar(const SnackBar(
                          //                     duration: Duration(seconds: 2),
                          //                     content: Text('Se debe seleccionar un ciclo.'),
                          //                     dismissDirection: DismissDirection.endToStart,
                          //                   ));
                          //                 }
                          //               },
                          //               child: const Text('Filtrar')
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const StudentsGrades()
                          //   ],
                          // ),
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
    );
  }
}