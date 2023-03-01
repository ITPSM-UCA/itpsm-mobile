import 'package:flutter/material.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/student_academic_information.dart';
import 'package:itpsm_mobile/widgets/students/academic_record/students_studied_subjects.dart';

class AcademicRecordScreen extends StatelessWidget {
  static const routeName = '/academicRecord';
  
  const AcademicRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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