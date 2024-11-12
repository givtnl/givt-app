import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_region/device_region.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_custom.dart';
import 'package:givt_app/features/email_signup/presentation/models/email_signup_uimodel.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSignupCubit
    extends CommonCubit<EmailSignupUiModel, EmailSignupCustom> {
  EmailSignupCubit(this._authRepository) : super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;

  Country _currentCountry = Country.nl;
  String _currentEmail = '';

  Future<void> init() async {
    emitLoading();

    _currentCountry = await getCountry();
    _currentEmail = await getEmail();

    emitData(
      EmailSignupUiModel(
        email: _currentEmail,
        country: _currentCountry,
        continueButtonEnabled: validateEmail(_currentEmail),
      ),
    );
  }

  Future<String> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(UserExt.tag)) {
        final user = UserExt.fromJson(
          jsonDecode(prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
        );

        return user.email;
      }
    } catch (_) {
      // ignore
    }

    return '';
  }

  Future<Country> getCountry() async {
    // Use user preference to fetch last used country
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(UserExt.tag)) {
      final user = UserExt.fromJson(
        jsonDecode(prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
      );

      return Country.fromCode(user.country);
    }

    // Otherwise use sim card country
    try {
      final countryCode = await DeviceRegion.getSIMCountryCode();

      if (countryCode != null && countryCode.isNotEmpty) {
        return Country.fromCode(countryCode);
      }
    } catch (_) {
      // On error use default country
      return _currentCountry;
    }

    // If no sim card country is found, use default country
    return _currentCountry;
  }

  /// Some logic to set the current API urls based on the country
  /// The method also updates the country iso in shared preferences
  Future<void> updateCountry(Country country) async {
    _currentCountry = country;

    var baseUrl = const String.fromEnvironment('API_URL_EU');
    var baseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');

    if (country.isUS) {
      baseUrl = const String.fromEnvironment('API_URL_US');
      baseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
    }

    log('Using API URL: $baseUrl');
    get_it.getIt<RequestHelper>().updateApiUrl(baseUrl, baseUrlAWS);
    get_it.getIt<RequestHelper>().country = country.countryCode;

    // update country iso in shared preferences
    final prefs = get_it.getIt<SharedPreferences>();
    unawaited(prefs.setString(Util.countryIso, country.countryCode));

    emitData(
      EmailSignupUiModel(
        email: _currentEmail,
        country: _currentCountry,
        continueButtonEnabled: validateEmail(_currentEmail),
      ),
    );
  }

  Future<void> updateEmail(String email) async {
    _currentEmail = email;

    emitData(
      EmailSignupUiModel(
        email: email,
        country: _currentCountry,
        continueButtonEnabled: validateEmail(email),
      ),
    );
  }

  bool validateEmail(String? email) {
    var result =
        email != null && !email.isEmpty && Util.emailRegEx.hasMatch(email);

    return result;
  }

  Future<void> login() async {
    if (!validateEmail(_currentEmail)) {
      // It shouldn't be possible to get here
      emitError('Invalid email address');
      return;
    }

    if (!_currentCountry.isUS) {
      // It shouldn't be possible to get here
      emitError("EU shouldn't make use of family login");
    }

    // Check if this is a different login or someone who logged in before
    await _authRepository.checkUserExt(email: _currentEmail);

    // Get info if this is a registered user
    final result = await _authRepository.checkEmail(email: _currentEmail);

    // When this is a registered user, we show the login page
    if (result.contains('true')) {
      emitCustom(EmailSignupCustom.loginFamily(_currentEmail));
      return;
    }

    // When this is a temp user, we show the register page
    if (result.contains('temp')) {
      emitCustom(EmailSignupCustom.registerFamily(_currentEmail));
      return;
    }

    // Otherwise we create a temp user
    final tempUser = TempUser.prefilled(
      email: _currentEmail,
      country: _currentCountry.countryCode,
      timeZoneId: await FlutterTimezone.getLocalTimezone(),
      amountLimit: _currentCountry.isUS ? 4999 : 499,
    );

    await _authRepository.registerUser(
      tempUser: tempUser,
      isNewUser: true,
    );
    
    emitCustom(EmailSignupCustom.registerFamily(_currentEmail));
  }
}
