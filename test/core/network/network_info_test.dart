import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:itpsm_mobile/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
void main() {
  late NetworkInfo network;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    network = NetworkInfoImpl(connectionChecker: mockConnectionChecker);
  });

  group('Network is connected', () {
    final hasConnection = Future.value(true);
    test('Should forward the call to InternetConnectionChecker.hasConnection', () async {
      when(mockConnectionChecker.hasConnection)
        .thenAnswer((_) => hasConnection);

      final result = network.isConnected;

      verify(mockConnectionChecker.hasConnection);
      expect(result, hasConnection);
    });
  });
}