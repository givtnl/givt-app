import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GivtRepositoryImpl.submitGivts auth gate', () {
    late SharedPreferences prefs;
    late _FakeNetworkInfo networkInfo;
    late _FakeApiService apiService;
    late GivtRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      networkInfo = _FakeNetworkInfo(isConnected: true);
      apiService = _FakeApiService();
      repository = GivtRepositoryImpl(apiService, prefs, networkInfo);
    });

    test('throws 401 when online without access token', () async {
      await prefs.setString(
        Session.tag,
        jsonEncode(
          Session(
            email: 'user@givt.app',
            userGUID: 'guid-1',
            accessToken: '',
            refreshToken: 'refresh',
            expires: DateTime.now().toUtc().add(const Duration(hours: 1)).toIso8601String(),
            expiresIn: 3600,
            isLoggedIn: true,
          ).toJson(),
        ),
      );

      expect(
        () => repository.submitGivts(
          guid: 'guid-1',
          body: const {'donations': <dynamic>[]},
        ),
        throwsA(
          isA<GivtServerFailure>().having(
            (e) => e.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      expect(apiService.submitCallCount, 0);
    });

    test('throws 401 when online and not logged in', () async {
      await prefs.setString(
        Session.tag,
        jsonEncode(
          Session(
            email: 'user@givt.app',
            userGUID: 'guid-1',
            accessToken: 'access',
            refreshToken: 'refresh',
            expires: DateTime.now().toUtc().add(const Duration(hours: 1)).toIso8601String(),
            expiresIn: 3600,
            isLoggedIn: false,
          ).toJson(),
        ),
      );

      expect(
        () => repository.submitGivts(
          guid: 'guid-1',
          body: const {'donations': <dynamic>[]},
        ),
        throwsA(isA<GivtServerFailure>()),
      );
      expect(apiService.submitCallCount, 0);
    });

    test('submits when online with valid session', () async {
      await prefs.setString(
        Session.tag,
        jsonEncode(
          Session(
            email: 'user@givt.app',
            userGUID: 'guid-1',
            accessToken: 'access',
            refreshToken: 'refresh',
            expires: DateTime.now().toUtc().add(const Duration(hours: 1)).toIso8601String(),
            expiresIn: 3600,
            isLoggedIn: true,
          ).toJson(),
        ),
      );
      apiService.submitResult = [42];

      final ids = await repository.submitGivts(
        guid: 'guid-1',
        body: const {
          'donations': <dynamic>[],
        },
      );

      expect(ids, [42]);
      expect(apiService.submitCallCount, 1);
    });

    test('allows offline submit path without token check failure before cache',
        () async {
      networkInfo.isConnected = false;
      await prefs.remove(Session.tag);

      // Offline: auth gate is skipped. API call may still fail; we only assert
      // the gate does not throw 401 before attempting the request.
      apiService.submitResult = [7];

      final ids = await repository.submitGivts(
        guid: 'guid-1',
        body: const {
          'donations': <dynamic>[],
        },
      );

      expect(ids, [7]);
      expect(apiService.submitCallCount, 1);
    });
  });
}

class _FakeNetworkInfo implements NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeApiService extends Fake implements APIService {
  int submitCallCount = 0;
  List<int> submitResult = const [];

  @override
  Future<List<int>> submitGivts({
    required Map<String, dynamic> body,
    required String guid,
  }) async {
    submitCallCount++;
    return submitResult;
  }
}
