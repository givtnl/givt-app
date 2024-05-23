import 'dart:async';

import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/domain/exceptions/not_logged_in_exception.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityChallengeVpcRepository {
  const GenerosityChallengeVpcRepository(
    this._addMemberRepository,
    this._authRepository,
    this._apiService,
    this._sharedPreferences,
  );

  final AddMemberRepository _addMemberRepository;
  final AuthRepository _authRepository;
  final APIService _apiService;
  final SharedPreferences _sharedPreferences;

  Future<void> addMembers(List<Member> list) async {
    _updateUrlsAndCountry();
    try {
      await _authRepository.updateFingerprintCertificate();
    } catch (e, s) {
      unawaited(
        LoggingInfo.instance.info(
          e.toString(),
          methodName: s.toString(),
        ),
      );
    }
    Session? session;
    try {
      session = await _authRepository.refreshToken(refreshUserExt: true);
    } catch (e, s) {
      unawaited(
        LoggingInfo.instance.info(
          e.toString(),
          methodName: s.toString(),
        ),
      );
    }
    if (true == session?.isLoggedIn) {
      await _addMemberRepository.addMembers(list);
    } else {
      throw const NotLoggedInException();
    }
  }

  void _updateUrlsAndCountry() {
    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');

    _apiService.updateApiUrl(baseUrl, baseUrlAWS);

    unawaited(
      _sharedPreferences.setString(
        Util.countryIso,
        Country.us.countryCode,
      ),
    );
  }
}
