import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc(
    this._campaignRepository,
    this._givtRepository,
  ) : super(const GiveState()) {
    on<GiveQRCodeScanned>(_qrCodeScanned);

    on<GiveAmountChanged>(_amountChanged);

    on<GiveOrganisationSelected>(_organisationSelected);
  }

  final CampaignRepository _campaignRepository;
  final GivtRepository _givtRepository;

  FutureOr<void> _qrCodeScanned(
    GiveQRCodeScanned event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final uri = Uri.parse(event.rawValue);
      final mediumId = utf8.decode(base64.decode(uri.queryParameters['code']!));
      final organisation = await _getOrganisation(mediumId);
      final transactionList = _createTransationList(mediumId, event.userGUID);

      await _givtRepository.submitGivts(
        guid: event.userGUID,
        body: {'donations': GivtTransaction.toJsonList(transactionList)},
      );

      emit(
        state.copyWith(
          status: GiveStatus.readyToGive,
          organisation: organisation,
          givtTransactions: transactionList,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  List<GivtTransaction> _createTransationList(String mediumId, String guid) {
    final transactionList = <GivtTransaction>[];
    final formattedDate = DateTime.now().toUtc().toIso8601String();
    for (var index = 0; index < state.collections.length; index++) {
      if (state.collections[index] == 0.0) continue;
      transactionList.add(
        GivtTransaction(
          guid: guid,
          amount: state.collections[index],
          beaconId: mediumId,
          timestamp: formattedDate,
          collectId: '${index + 1}',
        ),
      );
    }
    return transactionList;
  }

  Future<Organisation> _getOrganisation(String mediumId) async {
    final organisation = await _campaignRepository.getOrganisation(mediumId);
    organisation.copyWith(mediumId: mediumId);

    return organisation;
  }

  FutureOr<void> _amountChanged(
    GiveAmountChanged event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      emit(
        state.copyWith(
          status: GiveStatus.success,
          firstCollection: event.firstCollectionAmount,
          secondCollection: event.secondCollectionAmount,
          thirdCollection: event.thirdCollectionAmount,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _organisationSelected(
    GiveOrganisationSelected event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final organisation = await _getOrganisation(event.nameSpace);
      final transactionList =
          _createTransationList(event.nameSpace, event.userGUID);

      await _givtRepository.submitGivts(
        guid: event.userGUID,
        body: {'donations': GivtTransaction.toJsonList(transactionList)},
      );
      emit(
        state.copyWith(
          status: GiveStatus.readyToGive,
          organisation: organisation,
          givtTransactions: transactionList,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }
}
