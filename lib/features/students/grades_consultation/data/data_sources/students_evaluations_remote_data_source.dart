import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../../../core/errors/exceptions/http/server_exception.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/itpsm_utils.dart';
import '../../../../../core/utils/log/get_logger.dart';
import '../models/students_evaluations_model.dart';

abstract class StudentsEvaluationsRemoteDataSource {
  final String studentsEvaluationsPath = 'evaluations/student';

  /// Calls the http://itpsm-api-host/api/evaluations/student/{studentId} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<List<StudentsEvaluationsModel>> getstudentsEvaluations(int studentId, int periodId, String token);
}

class StudentsEvaluationsRemoteDataSourceImpl extends StudentsEvaluationsRemoteDataSource {
  static final Logger logger = getLogger();
  
  final http.Client client;

  StudentsEvaluationsRemoteDataSourceImpl({required this.client});
  
  @override
  Future<List<StudentsEvaluationsModel>> getstudentsEvaluations(int studentId, int periodId, String token) async {
    http.Response response = await client.get(
      ItpsmUtils.getApiUri('$studentsEvaluationsPath/$studentId'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: ItpsmUtils.getBearerTokenFormat(token),
      },
    ).timeout(responseTimeout, onTimeout: () => http.Response(ItpsmUtils.getTimeoutResponseBody(), 408));

    logger.d('StudentsEvaluations response body: ${response.body}');

    Map<String, dynamic> studentsEvaluationsResponse = json.decode(response.body);

    if(ItpsmUtils.apiResponseHasErrors(studentsEvaluationsResponse)) {
      logger.e('StudentsEvaluations error response body: ${json.encode(studentsEvaluationsResponse)}');
      throw ServerException(title: studentsEvaluationsResponse['errors']['title'], message: studentsEvaluationsResponse['errors']['detail']);
    }

    List<StudentsEvaluationsModel> evaluations = [];
    List<Map<String, dynamic>> studentsEvaluations = ItpsmUtils.getAttributesArrayFromApiResponse(studentsEvaluationsResponse);
    
    for (var evaluation in studentsEvaluations) {
      evaluations.add(StudentsEvaluationsModel.fromJson(evaluation));
    }

    return evaluations.where((evaluation) => evaluation.periodId == periodId).toList();
  }
}