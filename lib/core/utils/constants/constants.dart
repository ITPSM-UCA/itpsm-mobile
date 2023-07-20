import 'package:flutter_dotenv/flutter_dotenv.dart';

// Keys for SharedPreferences objects retrieval
const String authenticatedUserKey = 'AUTHENTICATED_USER';
const String studentsCurriculaKey = 'STUDENTS_CURRICULA';
const String studentsApprovedSubjectsKey = 'STUDENTS_APPROVED_SUBJECTS_KEY';
const String studentsEnrollmentsKey = 'STUDENTS_ENROLLMENTS_KEY';
const String studentsEvaluationsKey = 'STUDENTS_EVALUATIONS_KEY';

// const String localApiPath = 'http://172.26.160.1/api';
final String localApiPath = dotenv.get('api_url', fallback: 'NOT_FOUND');
const String apiName = 'ITPSM API';

// Icons provided by the API
const String logoutIcon = "logout";
const String mdSchoolIcon = 'MdSchool';

// Route names provided by the API
const String academicRecord = 'Historial academico';
const String gradesConsultation = 'Ver notas';

const String defaultString = 'No disponible';
const Duration responseTimeout = Duration(seconds: 60);