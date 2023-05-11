import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:itpsm_mobile/core/errors/exceptions/authentication/authentication_exception.dart';
import 'package:itpsm_mobile/features/authentication/data/data_sources/login_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/dummies/models/dummy_models.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'login_remote_data_source_test.mocks.dart' as mock;

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late Uri loginUri;
  late String expectedJson;
  late String expectedErrorJson;
  late LoginRemoteDataSource remoteDataSource;
  late mock.MockClient mockClient;
  
  setUp(() {
    loginUri = Uri.parse('$localApiPath/login');
    expectedJson = readFixture('authentication', 'login_response.json');
    expectedErrorJson = readFixture('authentication', 'login_error_response.json');
    mockClient = mock.MockClient();
    remoteDataSource = LoginRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpClientOkResponse() {
    // Simulate successful login POST request
    when(mockClient.post(loginUri, body: {'email': studentEmail, 'password': studentPassword}))
        .thenAnswer((_) async => http.Response(expectedJson, 200));
  }
  
  void setUpMockHttpClientErrorResponse() {
    // Simulate unsuccessful login POST request
    when(mockClient.post(loginUri, body: {'email': studentEmail, 'password': studentPassword}))
        .thenAnswer((_) async => http.Response(expectedErrorJson, 401));
  }

  group('login', () {
    test('Should perform a POST request at $localApiPath', () async {
      setUpMockHttpClientOkResponse();

      // 1. Get dummy login data
      await remoteDataSource.login(studentEmail, studentPassword);

      // 2. Verify the login POST request was executed
      verify(mockClient.post(loginUri, body: {'email': studentEmail, 'password': studentPassword}));
    });
    
    test('Should return AuthenticatedUserModel when the response code is 200', () async {
      setUpMockHttpClientOkResponse();

      // 1. Get dummy login data
      final response = await remoteDataSource.login(studentEmail, studentPassword);
      
      // 2. Verify the remote data source returns a [AuthenticatedUserModel]
      expect(response, dummyAuthUserModel);
    });

    test('Should throw AuthenticationException when the response code is different from 200', () async {
      setUpMockHttpClientErrorResponse();

      final call = remoteDataSource.login;
      
      // 1. Verify the remote data source returns a [AuthenticationException] 
      expect(() => call(studentEmail, studentPassword), throwsA(const TypeMatcher<AuthenticationException>()));
    });
  });
}