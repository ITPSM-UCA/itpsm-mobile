import 'package:flutter/material.dart';

class AcademicRecordScreen extends StatelessWidget {
  static const routeName = '/academicRecord';
  
  const AcademicRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: const [
            Text('Nombre del estudiante'),
            Text('Informacion del estudiante'),
            Text('Materias cursadas'),
          ],
        ),
      ),
    );
  }
}