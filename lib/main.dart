import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itpsm_mobile/screens/login/login_screen.dart';
import 'package:itpsm_mobile/screens/students/academic_record_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        AcademicRecordScreen.routeName:(context) => const AcademicRecordScreen()
      },
    );
  }
}
