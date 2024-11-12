import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/registration/cubit/us_signup_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/temp_user.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/util.dart';

class UsSignupCubit
    extends CommonCubit<UserExt, UsSignupCustom> {
  UsSignupCubit(
    FamilyAuthRepository authRepository,
  )   : _authRepository = authRepository,
        super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;

  Future<void> init() async {
    await _authRepository.refreshToken();
    final user = _authRepository.getCurrentUser();

    if (user == null) {
      emitError(null);
      return;
    }

    emitData(user);
  }

  Future<void> savePersonalInfo({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String country,
    required String phoneNumber,
    required String appLanguage,
    required String countryCode,
    required String profilePicture,
  }) async {
    emitLoading();

    try {
      final tempUser = TempUser(
        email: email,
        country: country,
        appLanguage: appLanguage,
        timeZoneId: await FlutterTimezone.getLocalTimezone(),
        amountLimit:
            country.toUpperCase() == Country.us.countryCode ? 4999 : 499,
        address: Util.defaultAddress,
        city: Util.defaultCity,
        postalCode: Util.defaultPostCode,
        firstName: firstName,
        iban: Util.defaultIban,
        lastName: lastName,
        password: password,
        phoneNumber: phoneNumber,
        accountNumber: Util.empty,
        sortCode: Util.empty,
        profilePicture: profilePicture,
      );

      await _authRepository.registerUser(
        tempUser: tempUser,
        isNewUser: false,
      );

      emitCustom(const UsSignupCustomSuccess());
    } catch (e, s) {
      emitSnackbarMessage(e.toString(), isError: true);
    }
  }
}
