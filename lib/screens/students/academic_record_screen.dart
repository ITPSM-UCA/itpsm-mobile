import 'package:flutter/material.dart';
import 'package:itpsm_mobile/screens/main_drawer/main_drawer_screen.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/student_academic_information.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/students_studied_subjects.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class AcademicRecordScreen extends StatelessWidget {
  static const routeName = '/academicRecord';
  
  const AcademicRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveWrapperData responsive = ResponsiveWrapper.of(context);

    List<Widget> buildAppBarActions(ThemeData theme, ResponsiveWrapperData responsive) {
      return responsive.isLargerThan(TABLET) ?
      [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.account_circle), 
          label: const Text('Información personal'),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.receipt_long), 
          label: const Text('Inscripción de materias'),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.history_edu), 
          label: const Text('Historial académico'),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.sticky_note_2), 
          label: const Text('Ver notas'),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
        ),
      ] : [];
    }
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('ITPSM'),
        automaticallyImplyLeading: false,
        actions: buildAppBarActions(theme, responsive),
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