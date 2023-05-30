import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/constants/constants.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_event.dart';

import '../../authentication/presentation/bloc/authentication_bloc.dart';

class MainDrawerScreen extends StatelessWidget {
  const MainDrawerScreen({super.key});

  ListTile _buildMenuItem(String text, String iconName, VoidCallback onTap, ThemeData theme) {
    IconData icon;
  
    switch(iconName) {
      case mdSchoolIcon: icon = Icons.school; break;
      case logoutIcon: icon = Icons.logout_rounded; break;
      default: icon = Icons.school; break;
    }
    
    // Changes in the API need to be done to remove this patch
    if(text == gradesConsultation) {
      icon = Icons.class_;
    }
    
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 25),
      title: Text(text, style: theme.textTheme.titleSmall)
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    final authProvider = context.read<AuthenticationBloc>();
    final authUser = authProvider.state.authenticatedUser;

    return Drawer(
      child: Column(children: [
        Container(
          height: 120,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'Workflow',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          )
        ),
        const SizedBox(height: 20),
        ...authUser?.platformMenus.reversed.toList().where((menu) => menu.name == academicRecord || menu.name == gradesConsultation).map((menu) {
          return _buildMenuItem(
            menu.name,
            menu.icon,
            () { navigator.pushReplacementNamed(menu.redirectTo); },
            theme
          );
        }).toList() ?? [],
        _buildMenuItem(
          'Cerrar Sesión',
          logoutIcon,
          () { authProvider.add(LogoutRequestedEvent()); },
          theme
        )
        // _buildMenuItem(
        //   'Información personal',
        //   Icons.account_circle,
        //   () => {},
        //   theme
        // ),
        // _buildMenuItem(
        //   'Inscripción de materias',
        //   Icons.receipt_long,
        //   () => {},
        //   theme
        // ),
        // _buildMenuItem(
        //   'Historial académico',
        //   Icons.history_edu,
        //   () => navigator.pushReplacementNamed(AcademicRecordScreen.routeName),
        //   theme
        // ),
        // _buildMenuItem(
        //   'Ver notas',
        //   Icons.sticky_note_2,
        //   () {},
        //   theme
        // ),
      ]),
    );
  }
}