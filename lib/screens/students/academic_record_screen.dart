import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:itpsm_mobile/features/drawer/presentation/main_drawer_screen.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/student_academic_information.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/students_studied_subjects.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../core/utils/constants/constants.dart';
import '../../features/authentication/presentation/bloc/authentication_bloc.dart';

class AcademicRecordScreen extends StatelessWidget {
  static const routeName = '/dashboard/historial-academico';
  
  const AcademicRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final responsive = ResponsiveWrapper.of(context);
    final authProvider = context.read<AuthenticationBloc>();
    final authUser = authProvider.state.authenticatedUser;

    TextButton buildMenuItem(String text, String iconName, VoidCallback onPressed) {
      IconData icon;
  
      switch(iconName) {
        case mdSchoolIcon: icon = Icons.school; break;
        case logoutIcon: icon = Icons.logout_rounded; break;
        default: icon = Icons.school; break;
      }
      
      return TextButton.icon(onPressed: onPressed, icon: Icon(icon, size: 25), label: Text(text));
    }

    List<TextButton> buildAppBarActions(ResponsiveWrapperData responsive) {
      if(responsive.isLargerThan(TABLET)) {
        final menu = authUser?.platformMenus.map((menu) {
          return buildMenuItem(menu.name, menu.icon, () { navigator.pushNamed(menu.redirectTo); });
        }).toList() ?? [];

        if(menu.isNotEmpty) {
          menu.add(buildMenuItem('Cerrar Sesión', logoutIcon, () => authProvider.add(LogoutRequestedEvent())));
        }

        return menu;
      }
      else { return []; }
    }
  
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text('ITPSM'),
        automaticallyImplyLeading: false,
        actions: buildAppBarActions(responsive),
        leading: Builder(
          builder: (BuildContext context) {
            return responsive.isLargerThan(TABLET) ?
            const SizedBox() :
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: const MainDrawerScreen(),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Aurelie Ankunding',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const StudentAcademicInformation(),
              ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 500
                ),
                child: const StudentsStudiedSubjects(),
              )
            ],
          ),
        )
      ),
    );
  }
}