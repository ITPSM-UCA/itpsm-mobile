import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_local_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_remote_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:itpsm_mobile/screens/students/academic_record_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/presentation/screens/login_screen.dart';

void main() {
  // Ensure the app does not allow landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ItpsmMobile());
}

class ItpsmMobile extends StatelessWidget {
  const ItpsmMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          return RepositoryProvider(
            create: (context) => AuthenticationRepositoryImpl(
              network: NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
              localDataSource: LoginLocalDataSourceImpl(sharedPreferences: snapshot.data!),
              remoteDataSource: LoginRemoteDataSourceImpl(client: http.Client())
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationBloc>(
                  create: (context) => AuthenticationBloc(repository: context.read<AuthenticationRepositoryImpl>()),
                ),
                BlocProvider<LoginCubit>(
                  create: (context) => LoginCubit(repository: context.read<AuthenticationRepositoryImpl>()),
                )
              ],
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return MaterialApp(
                    title: 'ITPSM Mobile',
                    builder: (context, child) => ResponsiveWrapper.builder(
                      child,
                      breakpoints: [
                        const ResponsiveBreakpoint.resize(350, name: MOBILE),
                        const ResponsiveBreakpoint.autoScale(600, name: TABLET),
                        const ResponsiveBreakpoint.resize(800, name: DESKTOP),
                        const ResponsiveBreakpoint.autoScale(1400, name: 'XL'),
                      ]
                    ),
                    theme: ThemeData(
                      useMaterial3: true,
                      colorSchemeSeed: Colors.indigo,
                      brightness: Brightness.light,
                      textTheme: const TextTheme(
                        titleLarge: TextStyle(
                          fontSize: 24
                        ),
                        titleMedium: TextStyle(
                          fontSize: 20
                        ),
                        titleSmall: TextStyle(
                          fontSize: 18
                        ),
                      )
                    ),
                    home: state.status == AuthenticationStatus.authenticated ? 
                      const AcademicRecordScreen() : const LoginScreen(),
                    routes: {
                      // LoginScreen.routeName: (context) => const LoginScreen(),
                      AcademicRecordScreen.routeName:(context) => const AcademicRecordScreen()
                    },
                  );
                }
              ),
            ),
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}

