import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:itpsm_mobile/core/utils/globals/globals.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_local_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_remote_data_source.dart';
import 'package:itpsm_mobile/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:itpsm_mobile/features/students/academic_record/presentation/screens/academic_record_screen.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/presentation/screens/grades_consultation_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/presentation/screens/login_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; 
  }
}

void main() async {
  FlutterError.onError = (details) {
    if(details.exception is FlutterError) {
      FlutterError.presentError(details);
      if (kReleaseMode) exit(1);
    }
  };
  
  // Ensure the app does not allow landscape mode
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HttpOverrides.global = MyHttpOverrides();

  runApp(const ItpsmMobile());
}

class ItpsmMobile extends StatelessWidget {

  Widget? _builderHome(AuthenticationState state) {
    if(state.status == AuthenticationStatus.authenticated) {
      return const GradesConsultationScreen();
    }
    else {
      return const LoginScreen();
    }
  }

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
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Globals.navigatorKey,
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
                    home: _builderHome(state),
                    routes: {
                      // LoginScreen.routeName: (context) => const LoginScreen(),
                      AcademicRecordScreen.routeName: (context) => const AcademicRecordScreen(),
                      GradesConsultationScreen.routeName: (context) => const GradesConsultationScreen()
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

