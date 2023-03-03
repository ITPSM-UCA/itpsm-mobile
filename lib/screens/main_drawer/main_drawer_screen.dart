import 'package:flutter/material.dart';
import 'package:itpsm_mobile/screens/students/academic_record_screen.dart';

class MainDrawerScreen extends StatelessWidget {
  const MainDrawerScreen({super.key});

  ListTile _buildMenuItem(String text, IconData icon, VoidCallback onTap, ThemeData theme) {

    return ListTile(
      onTap: () {},
      leading: Icon(icon, size: 25),
      title: Text(
        text,
        style: theme.textTheme.titleSmall,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NavigatorState navigator = Navigator.of(context);

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
        _buildMenuItem(
          'Información personal',
          Icons.account_circle,
          () => {},
          theme
        ),
        _buildMenuItem(
          'Inscripción de materias',
          Icons.receipt_long,
          () => {},
          theme
        ),
        _buildMenuItem(
          'Historial académico',
          Icons.history_edu,
          () => navigator.pushReplacementNamed(AcademicRecordScreen.routeName),
          theme
        ),
        _buildMenuItem(
          'Ver notas',
          Icons.sticky_note_2,
          () {},
          theme
        ),
      ]),
    );
  }
}