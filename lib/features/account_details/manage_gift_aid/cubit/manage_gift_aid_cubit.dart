import 'package:givt_app/features/account_details/manage_gift_aid/models/manage_gift_aid_card_scenario.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/models/manage_gift_aid_ui_model.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/uk_gift_aid_tax_year.dart';

class ManageGiftAidCubit extends CommonCubit<ManageGiftAidUIModel, void> {
  ManageGiftAidCubit(
    this._authRepository,
    this._donationOverviewRepository,
  ) : super(const BaseState.loading());

  final AuthRepository _authRepository;
  final DonationOverviewRepository _donationOverviewRepository;

  UserExt _user = const UserExt.empty();
  Future<void> Function()? _refreshUser;

  Future<void> init({
    required UserExt user,
    required Future<void> Function() refreshUser,
  }) async {
    _user = user;
    _refreshUser = refreshUser;
    await reload();
  }

  void syncUser(UserExt user) {
    _user = user;
    _emitData();
  }

  Future<void> reload() async {
    await inTryCatchFinally(
      inTry: () async {
        emitLoading();
        await _donationOverviewRepository.loadDonations();
        _emitData();
      },
      inCatch: (e, s) async {
        emitError(e.toString());
      },
    );
  }

  void toggleImpactAccordion() {
    final current = state;
    if (current is! DataState<ManageGiftAidUIModel, void>) return;
    final data = current.data;
    emitData(
      data.copyWith(impactAccordionExpanded: !data.impactAccordionExpanded),
    );
  }

  /// Returns `true` if the API call succeeded (caller may navigate).
  Future<bool> setGiftAidEnabled({required bool enabled}) async {
    var success = false;
    await inTryCatchFinally(
      inTry: () async {
        emitLoading();
        final ok = await _authRepository.changeGiftAid(
          guid: _user.guid,
          giftAid: enabled,
        );
        if (!ok) {
          emitSnackbarMessage('Request failed', isError: true);
          _emitData();
          return;
        }
        _user = _user.copyWith(isGiftAidEnabled: enabled);
        await _refreshUser?.call();
        _emitData();
        success = true;
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(e.toString(), isError: true);
        _emitData();
      },
    );
    return success;
  }

  void _emitData() {
    final now = DateTime.now();
    final taxYearIndex = ukGiftAidTaxYearIndexForDate(now);
    final displayYear = ukGiftAidTaxYearDisplayYear(now);

    final donations = _donationOverviewRepository.getDonations();
    final inYear = donations.where(
      (d) =>
          d.taxYear == taxYearIndex &&
          d.status.type == DonationStatusType.completed,
    );

    final totalGiven = inYear.fold<double>(0, (s, d) => s + d.amount);

    final hadGiftAidedDonation = inYear.any((d) => d.isGiftAidEnabled);

    final giftAidExtra = inYear
        .where((d) => d.isGiftAidEnabled)
        .fold<double>(0, (s, d) => s + d.amount * 0.25);

    final totalImpactTeal = totalGiven + giftAidExtra;

    final scenario = _resolveScenario(
      isGiftAidEnabled: _user.isGiftAidEnabled,
      hadGiftAidedDonation: hadGiftAidedDonation,
    );

    double extraOrPotential;
    double totalImpact;
    if (scenario == ManageGiftAidCardScenario.orangeOpportunity) {
      extraOrPotential = totalGiven * 0.25;
      totalImpact = totalGiven + extraOrPotential;
    } else {
      extraOrPotential = giftAidExtra;
      totalImpact = totalImpactTeal;
    }

    emitData(
      ManageGiftAidUIModel(
        taxYearIndex: taxYearIndex,
        displayYear: displayYear,
        scenario: scenario,
        isGiftAidEnabled: _user.isGiftAidEnabled,
        totalGiven: totalGiven,
        extraOrPotentialAmount: extraOrPotential,
        totalImpactAmount: totalImpact,
        impactAccordionExpanded: _previousAccordionExpanded(),
      ),
    );
  }

  bool _previousAccordionExpanded() {
    final current = state;
    if (current is DataState<ManageGiftAidUIModel, void>) {
      return current.data.impactAccordionExpanded;
    }
    return true;
  }

  static ManageGiftAidCardScenario _resolveScenario({
    required bool isGiftAidEnabled,
    required bool hadGiftAidedDonation,
  }) {
    if (isGiftAidEnabled || hadGiftAidedDonation) {
      return ManageGiftAidCardScenario.tealImpact;
    }
    return ManageGiftAidCardScenario.orangeOpportunity;
  }
}
