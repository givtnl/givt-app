import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/analytics_helper.dart';

part 'gift_aid_registration_custom.dart';
part 'gift_aid_registration_uimodel.dart';

/// Cubit that manages the Gift Aid registration step for UK users.
class GiftAidRegistrationCubit
    extends CommonCubit<GiftAidRegistrationUIModel, GiftAidRegistrationCustom> {
  GiftAidRegistrationCubit(
    this._authCubit,
    this._authRepository,
  ) : super(const BaseState.loading()) {
    _init();
  }

  final AuthCubit _authCubit;
  final AuthRepository _authRepository;
  GiftAidRegistrationUIModel? _model;

  Future<void> _init() async {
    final user = _authCubit.state.user;
    _model = GiftAidRegistrationUIModel(
      user: user,
      isCheckboxChecked: false,
    );
    emitData(_model!);
  }

  void onCheckboxChanged(bool value) {
    if (_model == null) return;

    _model = _model!.copyWith(isCheckboxChecked: value);
    emitData(_model!);

    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.giftAidRegistrationCheckboxChanged,
      eventProperties: {
        AnalyticsHelper.toggleStatusKey: value,
      },
    );
  }

  Future<void> activateForThisTaxYear() async {
    if (_model == null || !_model!.isCheckboxChecked) {
      return;
    }

    emitLoading();

    await inTryCatchFinally(
      inTry: () async {
        final guid = _model!.user.guid;
        await _authRepository.changeGiftAid(
          guid: guid,
          giftAid: true,
        );
        await _authCubit.refreshUser();

        emitCustom(const GiftAidRegistrationCustom.activated());
      },
      inCatch: (e, s) async {
        emitError(null);
      },
    );
  }

  Future<void> skipForNow() async {
    emitCustom(const GiftAidRegistrationCustom.skipped());
  }
}

