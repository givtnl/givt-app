import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSignupCubit
    extends CommonCubit<EmailSignupUiModel, EmailSignupCustom> {
  EmailSignupCubit(this._authRepository) : super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;

  Country? _currentCountry;
  String _currentEmail = '';
  String? _language;

  Future<void> init({String? language}) async {
    emitLoading();

    _currentCountry = await getStoredCountry();
    _currentEmail = await getEmail();
    _language = language ?? Util.defaultAppLanguage;

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

  Future<Country?> getStoredCountry() async {
    // Use user preference to fetch last used country
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(UserExt.tag)) {
      final user = UserExt.fromJson(
        jsonDecode(prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
      );

      return Country.fromCode(user.country);
    }

    return _currentCountry;
  }

  Country? get currentCountry => _currentCountry;

  /// Some logic to set the current API urls based on the country
  /// The method also updates the country iso in shared preferences
  Future<void> updateCountry(Country country) async {
    _currentCountry = country;

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

  void updateApi() {
    var baseUrl = const String.fromEnvironment('API_URL_EU');
    var baseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');

    if (_currentCountry!.isUS) {
      baseUrl = const String.fromEnvironment('API_URL_US');
      baseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
    }

    log('Using API URL: $baseUrl');
    get_it.getIt<RequestHelper>().updateApiUrl(baseUrl, baseUrlAWS);
    get_it.getIt<RequestHelper>().country = _currentCountry!.countryCode;
  }

  Future<void> updateEmail(String email) async {
    _currentEmail = email;

    emitData(
      EmailSignupUiModel(
        email: email,
        country: _currentCountry,
        continueButtonEnabled: shouldContinueBeEnabled(email),
      ),
    );
  }

  bool validateEmail(String? email) {
    final result =
        email != null && email.isNotEmpty && Util.emailRegEx.hasMatch(email);

    return result;
  }

  bool shouldContinueBeEnabled(String email) {
    return _currentCountry != null && validateEmail(email);
  }

  /// Logic to check if the email is already registered and emits the next step.
  /// - If the email is already registered, we show the login page
  /// - If the email is not (fully) registered, we show the register page
  ///
  /// _This method should only be used for the family app (currently US only)_
  Future<void> login() async {
    emitCustom(const EmailSignupCustom.checkingEmail());

    if (!shouldContinueBeEnabled(_currentEmail)) {
      // It shouldn't be possible to get here
      emitSnackbarMessage('Invalid email address');
      return;
    }

    if (!_currentCountry!.isUS) {
      // It shouldn't be possible to get here
      emitSnackbarMessage("EU shouldn't make use of family login");
      return;
    }

    // Check if this is a different login or someone who logged in before
    await _authRepository.checkUserExt(email: _currentEmail);

    // Get info if this is a registered user
    String result;
    try {
      result = await _authRepository.checkEmail(email: _currentEmail);
    } catch (e, s) {
      emitCustom(const EmailSignupCustom.noInternet());
      return;
    }

    // When this is a registered user, we show the login page
    if (result.contains('true')) {
      emitCustom(EmailSignupCustom.loginFamily(_currentEmail));
      return;
    }

    // When this is a temp user, we show the register page
    if (result.contains('temp')) {
      await _authRepository.login(_currentEmail, TempUser.defaultPassword);
      _authRepository.onRegistrationStarted();
      emitCustom(EmailSignupCustom.registerFamily(_currentEmail));
      return;
    }

    // Otherwise we create a temp user
    final tempUser = TempUser.prefilled(
      email: _currentEmail,
      appLanguage: _language!,
      country: _currentCountry!.countryCode,
      timeZoneId: await FlutterTimezone.getLocalTimezone(),
      amountLimit: _currentCountry!.isUS ? 4999 : 499,
    );

    try {
      await _authRepository.registerUser(
        tempUser: tempUser,
        isNewUser: true,
      );
      _authRepository.onRegistrationStarted();
      emitCustom(EmailSignupCustom.registerFamily(_currentEmail));
    } catch (e, s) {
      emitCustom(const EmailSignupCustom.error(
          'Could not register with entered e-mailadres. Please try again or submit a different e-mailadres.'));
    }
  }
}
