import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:sprintf/sprintf.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc(
    this._campaignRepository,
    this._givtRepository,
    this._beaconRepository,
  ) : super(const GiveState()) {
    on<GiveQRCodeScanned>(_qrCodeScanned);

    on<GiveAmountChanged>(_amountChanged);

    on<GiveOrganisationSelected>(_organisationSelected);

    on<GiveBTBeaconScanned>(_onBeaconScanned);

    on<GiveCheckLastDonation>(_checkLastDonation);
  }

  final CampaignRepository _campaignRepository;
  final GivtRepository _givtRepository;
  final BeaconRepository _beaconRepository;

  FutureOr<void> _qrCodeScanned(
    GiveQRCodeScanned event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final uri = Uri.parse(event.rawValue);
      final mediumId = utf8.decode(base64.decode(uri.queryParameters['code']!));

      await _processGivts(
        namespace: mediumId,
        userGUID: event.userGUID,
        emit: emit,
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
      await _processGivts(
        namespace: event.nameSpace,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _checkLastDonation(
    GiveCheckLastDonation event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final lastDonatedOrganisation =
          await _campaignRepository.getLastOrganisationDonated();
      emit(state.copyWith(organisation: lastDonatedOrganisation));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _onBeaconScanned(
    GiveBTBeaconScanned event,
    Emitter<GiveState> emit,
  ) async {
    if (state.status == GiveStatus.processingBeaconData) {
      return;
    }
    emit(state.copyWith(status: GiveStatus.processingBeaconData));
    try {
      final hex = StringBuffer();
      for (final b in event.serviceData[event.serviceUUID]!) {
        hex.write(sprintf('%02x', [b]));
      }

      final beaconData = hex.toString();
      final contains = beaconData.contains('61f7ed01') ||
          beaconData.contains('61f7ed02') ||
          beaconData.contains('61f7ed03');

      if (!contains) {
        emit(state.copyWith(status: GiveStatus.success));
        return;
      }

      final startIndex = beaconData.indexOf('61f7ed');
      final namespace = beaconData.substring(startIndex, startIndex + 20);
      final instance = beaconData.substring(startIndex + 20, startIndex + 32);
      final beaconId = '$namespace.$instance';
      final msg = 'Beacon detected $beaconId | RSSI: ${event.rssi}';

      // if (beaconData.substring(22, 24) != '20') {
      //   log('No voltage $msg');
      //   return;
      // }

      await _checkBatteryVoltage(
        int.tryParse(
          beaconData.substring(26, 30),
          radix: 16,
        ),
        msg,
        event.userGUID,
        beaconId,
      );

      final a = beaconId[21];
      if (event.threshold) {
        if (a == 'a') {
          /// area filter
          emit(state.copyWith(status: GiveStatus.processingBeaconData));
          return;
        }

        await _processGivts(
          namespace: namespace,
          userGUID: event.userGUID,
          emit: emit,
        );
        return;
      }
      if (beaconId.length > 20 && a == 'a') {
        /// donate to beacon
        await _processGivts(
          namespace: namespace,
          userGUID: event.userGUID,
          emit: emit,
        );
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  Future<void> _processGivts({
    required String namespace,
    required String userGUID,
    required Emitter<GiveState> emit,
  }) async {
    final organisation = await _getOrganisation(namespace);
    final transactionList = _createTransationList(namespace, userGUID);

    await _campaignRepository.saveLastDonation(
      organisation.copyWith(
        mediumId: namespace,
      ),
    );

    await _givtRepository.submitGivts(
      guid: userGUID,
      body: {'donations': GivtTransaction.toJsonList(transactionList)},
    );
    emit(
      state.copyWith(
        status: GiveStatus.readyToGive,
        organisation: organisation,
        givtTransactions: transactionList,
      ),
    );
  }

  Future<void> _checkBatteryVoltage(
    int? batteryVoltage,
    String msg,
    String userGUID,
    String beaconId,
  ) async {
    if (batteryVoltage == null) {
      return;
    }
    log(msg);
    // check for low battery voltage
    if (batteryVoltage > 2450) {
      return;
    }
    if (batteryVoltage == 0) {
      return;
    }
    // send battery status
    await _beaconRepository.sendBeaconBatteryStatus(
      guid: userGUID,
      beaconId: beaconId,
      batteryVoltage: batteryVoltage,
    );
  }
}
