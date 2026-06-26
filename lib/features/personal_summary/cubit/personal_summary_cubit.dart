import 'dart:async';
import 'dart:io';

import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/domain/personal_summary_aggregation.dart';
import 'package:givt_app/features/personal_summary/models/models.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/shared/models/givt.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/giving_goal_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class PersonalSummaryCubit
    extends CommonCubit<PersonalSummaryUIModel, PersonalSummaryCustom> {
  PersonalSummaryCubit(
    this._givtRepository,
    this._givingGoalRepository,
    this._collectGroupRepository,
  ) : super(const BaseState.loading());

  final GivtRepository _givtRepository;
  final GivingGoalRepository _givingGoalRepository;
  final CollectGroupRepository _collectGroupRepository;

  List<Givt> _allGivts = const [];
  List<ExternalDonation> _allExternalDonations = const [];
  List<CollectGroup> _collectGroups = const [];
  GivingGoal _givingGoal = const GivingGoal.empty();
  int _selectedYear = DateTime.now().year;
  bool _isSavingGoal = false;

  bool get isSavingGoal => _isSavingGoal;

  Future<void> init() async {
    await _loadAll();
  }

  Future<void> refresh() async {
    await _loadAll();
  }

  Future<void> selectPreviousYear() async {
    final uiModel = _currentUiModelOrNull();
    if (uiModel == null || !uiModel.canGoToPreviousYear) {
      return;
    }
    _selectedYear = uiModel.selectedYear - 1;
    _emitData();
  }

  Future<void> selectNextYear() async {
    final uiModel = _currentUiModelOrNull();
    if (uiModel == null || !uiModel.canGoToNextYear) {
      return;
    }
    _selectedYear = uiModel.selectedYear + 1;
    _emitData();
  }

  void requestAddDonationSheet() {
    emitCustom(const ShowAddDonationSheet());
  }

  void navigateToForYouList() {
    emitCustom(const NavigateToForYouList());
  }

  void navigateToExternalDonationCreate() {
    emitCustom(const NavigateToExternalDonationCreate());
  }

  void openGivingGoalSheet() {
    emitCustom(const ShowGivingGoalSheet());
  }

  Future<bool> saveGivingGoal({
    required int amount,
    required GivingGoalFrequency frequency,
  }) async {
    if (_isSavingGoal) {
      return false;
    }
    _isSavingGoal = true;
    _emitData();

    try {
      final body = GivingGoal(amount: amount, frequency: frequency).toJson();
      if (_givingGoal.id != null && _givingGoal.hasGoal) {
        _givingGoal = await _givingGoalRepository.updateGivingGoal(
          id: _givingGoal.id!,
          body: body,
        );
      } else {
        _givingGoal = await _givingGoalRepository.addGivingGoal(body: body);
      }
      _isSavingGoal = false;
      _emitData();
      emitCustom(const PersonalSummaryGoalSaved());
      return true;
    } on GivtServerFailure catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      return _handleGoalMutationFailure(error.body.toString());
    } on SocketException {
      return _handleGoalMutationFailure('no_internet');
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      return _handleGoalMutationFailure(error.toString());
    }
  }

  Future<bool> removeGivingGoal() async {
    if (_isSavingGoal) {
      return false;
    }
    _isSavingGoal = true;
    _emitData();

    try {
      await _givingGoalRepository.removeGivingGoal();
      _givingGoal = const GivingGoal.empty();
      _isSavingGoal = false;
      _emitData();
      emitCustom(const PersonalSummaryGoalSaved());
      return true;
    } on GivtServerFailure catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      return _handleGoalMutationFailure(error.body.toString());
    } on SocketException {
      return _handleGoalMutationFailure('no_internet');
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      return _handleGoalMutationFailure(error.toString());
    }
  }

  bool _handleGoalMutationFailure(String message) {
    _isSavingGoal = false;
    emitCustom(
      PersonalSummaryGoalMutationFailed(
        isNoInternet: message == 'no_internet',
        message: message == 'no_internet' ? null : message,
      ),
    );
    _emitData();
    return false;
  }

  Future<void> _loadAll() async {
    emitLoading();
    try {
      final results = await Future.wait([
        _givtRepository.fetchGivts(),
        _loadExternalDonations(),
        _givingGoalRepository.fetchGivingGoal(),
      ]);

      _allGivts = results[0] as List<Givt>;
      _allExternalDonations = results[1] as List<ExternalDonation>;
      _givingGoal = results[2] as GivingGoal;
      _collectGroups = await _loadCollectGroupsSafely();

      final availableYears = deriveAvailableYears(
        givts: _allGivts,
        externalDonations: _allExternalDonations,
      );
      if (!availableYears.contains(_selectedYear)) {
        _selectedYear = availableYears.first;
      }

      _emitData();
    } on GivtServerFailure catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      emitError(error.body.toString());
    } on SocketException {
      emitError('no_internet');
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      emitError(error.toString());
    }
  }

  Future<List<ExternalDonation>> _loadExternalDonations() {
    final now = DateTime.now();
    return _givtRepository.fetchExternalDonationSummary(
      fromDate: DateTime(2017).toIso8601String(),
      // Use start of next year so late gifts on 31 Dec are not cut off when the
      // API treats endDate as an exclusive instant.
      tillDate: DateTime(now.year + 1, 1, 1).toIso8601String(),
    );
  }

  Future<List<CollectGroup>> _loadCollectGroups() async {
    var collectGroups = await _collectGroupRepository.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await _collectGroupRepository.fetchCollectGroupList();
    }
    return collectGroups;
  }

  Future<List<CollectGroup>> _loadCollectGroupsSafely() async {
    try {
      return await _loadCollectGroups();
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      return const [];
    }
  }

  PersonalSummaryUIModel? _currentUiModelOrNull() {
    final currentState = state;
    if (currentState is DataState<PersonalSummaryUIModel, PersonalSummaryCustom>) {
      return currentState.data;
    }
    return null;
  }

  void _emitData() {
    if (isClosed) {
      return;
    }
    final uiModel = buildPersonalSummaryUIModel(
      allGivts: _allGivts,
      allExternalDonations: _allExternalDonations,
      collectGroups: _collectGroups,
      givingGoal: _givingGoal,
      selectedYear: _selectedYear,
    );
    emitData(uiModel);
  }
}
