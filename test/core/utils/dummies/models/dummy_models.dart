import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_platform_menu_model.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_role_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_approved_subjects_model.dart';
import 'package:itpsm_mobile/features/students/academic_record/data/models/students_curricula_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/enrollment_model.dart';
import 'package:itpsm_mobile/features/students/grades_consultation/data/models/students_evaluations_model.dart';

import '../../constants/constants.dart';

const dummyAuthUserModel = AuthenticatedUserModel(
    id: 15,
    name: 'Aurelie Ankunding',
    email: studentEmail,
    token:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxNyIsImp0aSI6ImYyZTE3Njg5Yzk2MmExNGYxODQ1ZjMwOWY2ZTVjNGEzNjdiNjc1ZWMxMGYxY2FmNmI1ZTdlZTk3YWFmNzFjM2YwOTFmNDViMWUyYmE1NjE5IiwiaWF0IjoxNjc5MDMxNjcyLjk4MTY5MSwibmJmIjoxNjc5MDMxNjcyLjk4MTY5MywiZXhwIjoxNjc5MDM4ODcyLjk1NTUxLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.lWqM6G30DRMFvUbGOAYRXvqgC3CqHpyxVm9tos37Fg3J4uQJV-JQwfdd-DIshIb_FfAaD62llcJcPs7Cn_nsbY7k33Z9mlma2N3-YvXj-2nOzwOM-7axoiobL4lj5_OO5wvXIQNXC04FrUz_bWYLJntoBSXBF98zWkxkyvWdlpycfiuigan6MPXBzz6_mbFvQZepUQlzKRGThKmtOzn4eYHp9w8UYSxUIIkCJuXlB4VlE_6dpt_zOqLDyTrVRjUUGddYxirTJCWpBzqbRXIOjaS5vZJZF_ImfCDd0p4kpPGY24Eg-jy3KdHDx0CAwGGNbeYA1EUmD2G-Iuz7-xK0QOhfmLt5LU152EQbnFKZKoL5IeVMnhQonj0X1p6Q_Ha-4YKbwwonjMifhM095Pi4GxI0KRdfatwwYJLbjGpX6PD7iu1TKRq0jF-zClSX4Me4EWf9iZqUjjDimgmc0PxxF4AAA_yRDeKE8ZvskTiCoiScJgbTZWl-fCZSwZpfiOJT8B7RAx1Pjij9WoE-PRVGOXS0hzZ3XHd_RvxXVUhMphT8dn9hXSe3GYq1iBhVX_RNSJV7NsJAQx4aaCFRt6KdC2315sIODSTc11R_8S94ye33ly8OnpFDmzYSGiCQXUvcyhRnCG-2LKTq_lgatuddXT-LDrN-SW2mGjVVh7ASQM0',
    tokenType: 'Bearer',
    expiresAt: '2023-03-17 05:41:13',
    systemReferenceId: 10,
    roles: [
      AuthenticatedUserRoleModel(id: 1, name: 'student')
    ],
    platformMenus: [
      AuthenticatedUserPlatformMenuModel(
          id: 8,
          name: 'Información personal',
          redirectTo: 'dashboard/informacion-personal',
          icon: 'MdSchool'),
      AuthenticatedUserPlatformMenuModel(
          id: 9,
          name: 'Inscripción de materias',
          redirectTo: 'dashboard/inscripcion-de-materias',
          icon: 'MdSchool'),
      AuthenticatedUserPlatformMenuModel(
          id: 10,
          name: 'Historial academico',
          redirectTo: 'dashboard/historial-academico',
          icon: 'MdSchool'),
      AuthenticatedUserPlatformMenuModel(
          id: 11,
          name: 'Ver notas',
          redirectTo: 'dashboard/notas',
          icon: 'MdSchool'),
    ]);

const dummyStdCurriculaModel = StudentsCurriculaModel(
  // uv: 0,
  cum: 8.9,
  // status: 'A',
  studentId: 1,
  // entryYear: 2017,
  // curriculumId: 2,
  // scholarshipId: 2,
  // graduationYear: 2022,
  // scholarshipRate: 150,
  cucrriculaName:
      'Plan 2019-2020 de la carrera Técnico Superior en Hostelería y Turismo',
);

const dummyStdApdSubModel = [
  StudentsApprovedSubjectsModel(
      name: 'Preparación de Bebidas',
      finalScore: 8.5,
      isApproved: 1,
      teacherName: 'Nickolas Brown',
      enrollment: 1,
      periodCode: 3,
      periodYear: 2022,
      uv: 5),
  StudentsApprovedSubjectsModel(
      name: 'Procesos Constructivos para Viviendas',
      finalScore: 5.6,
      isApproved: 1,
      teacherName: 'Alison Erdman',
      enrollment: 4,
      periodCode: 2,
      periodYear: 2022,
      uv: 5)
];

final dummyStdEvsModel = [
  StudentsEvaluationsModel(
      id: 1,
      name: 'Parcial 1',
      description: 'Parcial 1',
      date: DateTime.parse('2022-02-02'),
      percentage: 25,
      sectionId: 1,
      evaluationScore: 8,
      periodId: 3,
      subjectId: 37,
      subjectName: 'Preparación de Bebidas',
      subjectFinalScore: 8.5),
  StudentsEvaluationsModel(
      id: 3,
      name: 'Parcial 2',
      description: 'Parcial 2',
      date: DateTime.parse('2022-02-05'),
      percentage: 25,
      sectionId: 1,
      evaluationScore: 10,
      periodId: 3,
      subjectId: 37,
      subjectName: 'Preparación de Bebidas',
      subjectFinalScore: 8.5)
];

const dummyStdEmts = [
  EnrollmentModel(
    id: 2, 
    code: 2, 
    year: 2022, 
    status: 'C'
  ),
  EnrollmentModel(
    id: 3, 
    code: 3, 
    year: 2022, 
    status: 'A'
  )
];
