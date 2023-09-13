import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc(
    this._campaignRepository,
    this._givtRepository,
    this._beaconRepository,
    this._collectGroupRepository,
  ) : super(const GiveState()) {
    on<GiveQRCodeScanned>(_qrCodeScanned);

    on<GiveQRCodeScannedOutOfApp>(_qrCodeScannedOutOfApp);

    on<GiveConfirmQRCodeScannedOutOfApp>(_confirmQRCodeScannedOutOfApp);

    on<GiveAmountChanged>(_amountChanged);

    on<GiveGPSLocationChanged>(_gpsLocationChanged);

    on<GiveGPSConfirm>(_gpsConfirm);

    on<GiveOrganisationSelected>(_organisationSelected);

    on<GiveBTBeaconScanned>(_onBeaconScanned);

    on<GiveCheckLastDonation>(_checkLastDonation);

    on<GiveToLastOrganisation>(_onGiveToLastOrganisation);
  }

  final CampaignRepository _campaignRepository;
  final GivtRepository _givtRepository;
  final BeaconRepository _beaconRepository;
  final CollectGroupRepository _collectGroupRepository;

  FutureOr<void> _qrCodeScanned(
    GiveQRCodeScanned event,
    Emitter<GiveState> emit,
  ) async {
    if (state.status == GiveStatus.loading ||
        state.status == GiveStatus.readyToGive) {
      return;
    }
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final uri = Uri.parse(event.rawValue);
      final mediumId = utf8.decode(base64.decode(uri.queryParameters['code']!));

      await _checkQRCode(mediumId: mediumId, emit: emit);

      await _processGivts(
        namespace: mediumId,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  List<GivtTransaction> _createTransationList(String mediumId, String guid) {
    final transactionList = <GivtTransaction>[];
    final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(
      DateTime.now().toUtc(),
    );
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
    return organisation.copyWith(mediumId: mediumId);
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
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
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
      emit(
        state.copyWith(
          organisation: lastDonatedOrganisation,
          status: GiveStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _onGiveToLastOrganisation(
    GiveToLastOrganisation event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      await _processGivts(
        namespace: state.organisation.mediumId!,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
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
          namespace: beaconId,
          userGUID: event.userGUID,
          emit: emit,
        );
        return;
      }
      if (beaconId.length > 20 && a == 'a') {
        /// donate to beacon
        await _processGivts(
          namespace: beaconId,
          userGUID: event.userGUID,
          emit: emit,
        );
      }
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  Future<void> _processGivts({
    required String namespace,
    required String userGUID,
    required Emitter<GiveState> emit,
  }) async {
    if (state.status == GiveStatus.readyToGive) {
      return;
    }
    final organisation = await _getOrganisation(namespace);
    final transactionList = _createTransationList(namespace, userGUID);

    await _campaignRepository.saveLastDonation(
      organisation,
    );
    try {
      await LoggingInfo.instance.info('Submitting Givts');
      await _givtRepository.submitGivts(
        guid: userGUID,
        body: {'donations': GivtTransaction.toJsonList(transactionList)},
      );
    } on SocketException catch (e) {
      log(e.toString());
      emit(
        state.copyWith(
          organisation: organisation,
          status: GiveStatus.noInternetConnection,
        ),
      );
      return;
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      log('StatusCode:$statusCode Body:$body');
      await LoggingInfo.instance.error(
        body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(status: GiveStatus.error),
      );
      return;
    }

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
    await LoggingInfo.instance.info(msg);
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

  FutureOr<void> _qrCodeScannedOutOfApp(
    GiveQRCodeScannedOutOfApp event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      await LoggingInfo.instance
          .info('QR Code scanned out of app ${event.encodedMediumId}');
      final mediumId = utf8.decode(base64.decode(event.encodedMediumId));

      await _checkQRCode(mediumId: mediumId, emit: emit);

      final organisation = await _getOrganisation(mediumId);
      final transactionList = _createTransationList(
        mediumId,
        event.userGUID,
      );

      emit(
        state.copyWith(
          status: GiveStatus.readyToConfirm,
          organisation: organisation,
          givtTransactions: transactionList,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _confirmQRCodeScannedOutOfApp(
    GiveConfirmQRCodeScannedOutOfApp event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    await _campaignRepository.saveLastDonation(
      state.organisation.copyWith(
        mediumId: state.organisation.mediumId,
      ),
    );
    try {
      await _givtRepository.submitGivts(
        guid: state.givtTransactions.first.guid,
        body: {'donations': GivtTransaction.toJsonList(state.givtTransactions)},
      );
      emit(state.copyWith(status: GiveStatus.readyToGive));
    } on SocketException catch (e, stackTrace) {
      log(e.toString());
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: GiveStatus.noInternetConnection,
        ),
      );
      return;
    }
  }

  FutureOr<void> _gpsLocationChanged(
    GiveGPSLocationChanged event,
    Emitter<GiveState> emit,
  ) async {
    if (state.status == GiveStatus.readyToConfirmGPS) {
      return;
    }
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final organisations = await _collectGroupRepository.getCollectGroupList();
      final locations = <Location>[];
      for (final org in organisations) {
        locations.addAll(org.locations);
      }
      for (final location in locations) {
        if (location.end == null || location.begin == null) {
          continue;
        }
        // final currentTime = DateTime.now().toUtc();
        // if (!location.end!.isBefore(currentTime) &&
        //     !location.begin!.isAfter(currentTime)) {
        //   continue;
        // }
        final distance = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          event.latitude,
          event.longitude,
        );
        if (distance < location.radius) {
          await LoggingInfo.instance.info(
            'Location ${location.name} found in radius at $distance meters',
          );

          /// if no nearest location set nearest location
          if (state.nearestLocation.beaconId.isEmpty) {
            emit(
              state.copyWith(
                nearestLocation: location,
              ),
            );
            continue;
          }
          final distanceBetweenPreviousLocation = Geolocator.distanceBetween(
            state.nearestLocation.latitude,
            state.nearestLocation.longitude,
            event.latitude,
            event.longitude,
          );

          /// if closer update nearest location
          if (distanceBetweenPreviousLocation > distance) {
            await LoggingInfo.instance.info(
              'Location ${location.name} is closer at $distance meters',
            );
            emit(
              state.copyWith(
                nearestLocation: location,
              ),
            );
            continue;
          }
        }
      }
      if (state.nearestLocation.beaconId.isNotEmpty) {
        final org = await _getOrganisation(state.nearestLocation.beaconId);
        log('Giving to ${state.nearestLocation.name}');
        emit(
          state.copyWith(
            status: GiveStatus.readyToConfirmGPS,
            organisation: org,
            instanceName: state.nearestLocation.name,
          ),
        );
      }
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  FutureOr<void> _gpsConfirm(
    GiveGPSConfirm event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      await _processGivts(
        namespace: state.nearestLocation.beaconId,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  /// Search for the beacon that belongs to the given [mediumId]
  /// and return the instanceName that belongs to the beacon
  Future<QrCode> _getCollectGroupInstanceName(String mediumId) async {
    final collectGroupList =
        await _collectGroupRepository.getCollectGroupList();
    if (!mediumId.contains('.')) {
      return const QrCode.empty();
    }
    final namespace = mediumId.split('.').first;
    final instance = mediumId.split('.').last;
    return collectGroupList
        .where((org) => org.nameSpace.startsWith(namespace))
        .expand((org) => org.qrCodes)
        .firstWhere(
          (element) => element.instance.endsWith(instance),
          orElse: () => const QrCode.empty(),
        );
  }

  /// Search for the qrCode that belongs to the given [mediumId]
  Future<void> _checkQRCode({
    required String mediumId,
    required Emitter<GiveState> emit,
  }) async {
    final qrCode = await _getCollectGroupInstanceName(mediumId);

    if (qrCode.instance.isEmpty) {
      emit(state.copyWith(status: GiveStatus.error));
      return;
    }

    if (!qrCode.isActive) {
      final org = await _getOrganisation(mediumId);
      emit(
        state.copyWith(
          status: GiveStatus.beaconNotActive,
          organisation: org,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        instanceName: qrCode.name,
      ),
    );
  }
}
