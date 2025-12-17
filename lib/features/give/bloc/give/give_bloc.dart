import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    on<GiveSubmitTransactions>(_submitTransactions);

    on<GiveAmountChanged>(_amountChanged);

    on<GiveGPSLocationChanged>(_gpsLocationChanged);

    on<GiveGPSConfirm>(_gpsConfirm);

    on<GiveOrganisationSelected>(_organisationSelected);

    on<GiveBTBeaconScanned>(_onBeaconScanned);

    on<GiveCheckLastDonation>(_checkLastDonation);

    on<GiveToLastOrganisation>(_onGiveToLastOrganisation);

    on<GiveStripeRegistrationError>(_onStripeRegistrationError);

    on<GiveReset>(_onGiveReset);
  }

  final CampaignRepository _campaignRepository;
  final GivtRepository _givtRepository;
  final BeaconRepository _beaconRepository;
  final CollectGroupRepository _collectGroupRepository;

  // Flag to track if the BT scan page is still active
  bool _isBTScanPageActive = true;

  @override
  void onTransition(Transition<GiveEvent, GiveState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  /// Called when the BT scan page is being disposed
  void onBTScanPageDisposed() {
    _isBTScanPageActive = false;
    LoggingInfo.instance.info(
      'BT scan page disposed - beacon processing disabled',
    );
  }

  /// Called when the BT scan page is being initialized
  void onBTScanPageInitialized() {
    _isBTScanPageActive = true;
    LoggingInfo.instance.info(
      'BT scan page initialized - beacon processing enabled',
    );
  }

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
      final mediumId = utf8.decode(base64.decode(event.encodedMediumId));

      await _checkQRCode(mediumId: mediumId, emit: emit);

      if (state.status == GiveStatus.beaconNotActive ||
          state.status == GiveStatus.error) {
        return;
      }

      await _processGivts(
        namespace: mediumId,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  List<GivtTransaction> _createTransationList({
    required String mediumId,
    required String guid,
    String? goalId,
    List<double>? collections,
  }) {
    final transactionList = <GivtTransaction>[];
    final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(
      DateTime.now().toUtc(),
    );
    final amounts = collections ?? state.collections;
    for (var index = 0; index < amounts.length; index++) {
      if (amounts[index] == 0.0) continue;
      transactionList.add(
        GivtTransaction(
          guid: guid,
          amount: amounts[index],
          beaconId: mediumId,
          timestamp: formattedDate,
          collectId: '${index + 1}',
          goalId: goalId,
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
    try {
      // If we have an organisation (from QR code), recreate transactions with new amounts
      // This handles both readyToGive state and cases where state might be different but org exists
      if (state.organisation.mediumId != null &&
          state.organisation.mediumId!.isNotEmpty) {
        final mediumId = state.organisation.mediumId!;
        // Get userGUID from state (stored during QR scan)
        final userGUID = state.userGUID;

        LoggingInfo.instance.info(
          'Amount changed - retrieved userGUID from state: $userGUID',
        );

        if (userGUID.isEmpty) {
          // If no userGUID, we can't create transactions - emit success to fall back to normal flow
          LoggingInfo.instance.warning(
            'Cannot create transactions without userGUID. Falling back to normal flow. '
            'status: ${state.status}',
          );
          emit(
            state.copyWith(
              status: GiveStatus.success,
              firstCollection: event.firstCollectionAmount,
              secondCollection: event.secondCollectionAmount,
              thirdCollection: event.thirdCollectionAmount,
            ),
          );
          return;
        }

        // Capture organisation and other important state before updating
        final currentOrganisation = state.organisation;
        final currentInstanceName = state.instanceName;
        final currentAfterGivingRedirection = state.afterGivingRedirection;

        // Update collections first
        final updatedState = state.copyWith(
          firstCollection: event.firstCollectionAmount,
          secondCollection: event.secondCollectionAmount,
          thirdCollection: event.thirdCollectionAmount,
        );

        // Recreate transactions with new amounts using the updated collections
        final transactionList = _createTransationList(
          mediumId: mediumId,
          guid: userGUID,
          collections: [
            event.firstCollectionAmount,
            event.secondCollectionAmount,
            event.thirdCollectionAmount,
          ],
        );

        emit(
          updatedState.copyWith(
            status: GiveStatus.readyToGive,
            givtTransactions: transactionList,
            organisation:
                currentOrganisation, // Explicitly preserve organisation
            instanceName: currentInstanceName, // Preserve instance name
            afterGivingRedirection:
                currentAfterGivingRedirection, // Preserve redirect
          ),
        );

        LoggingInfo.instance.info(
          'Amount changed in QR flow - orgName: ${currentOrganisation.organisationName}, '
          'mediumId: ${currentOrganisation.mediumId}, '
          'transactions: ${transactionList.length}, '
          'newStatus: readyToGive',
        );
      } else {
        LoggingInfo.instance.info(
          'Amount changed in NORMAL flow - mediumId: ${state.organisation.mediumId}, '
          'hasOrg: ${state.organisation.mediumId?.isNotEmpty ?? false}, '
          'status: ${state.status}, '
          'newStatus: success',
        );
        emit(
          state.copyWith(
            status: GiveStatus.success,
            firstCollection: event.firstCollectionAmount,
            secondCollection: event.secondCollectionAmount,
            thirdCollection: event.thirdCollectionAmount,
          ),
        );
      }
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
        goalId: event.goalId,
      );
      emit(state.copyWith(status: GiveStatus.processed));
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
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
      final lastDonatedOrganisation = await _campaignRepository
          .getLastOrganisationDonated();
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
        namespace: state.organisation.mediumId!.split('.').first,
        userGUID: event.userGUID,
        emit: emit,
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
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

    // Add safety check: if the BT scan page is no longer active, don't process beacons
    // This prevents background processing when user has navigated away
    if (!_isBTScanPageActive) {
      LoggingInfo.instance.info(
        'Ignoring beacon scan - BT scan page no longer active',
      );
      return;
    }

    emit(state.copyWith(status: GiveStatus.processingBeaconData));
    try {
      final startIndex = event.beaconData.indexOf('61f7ed');
      final namespace = event.beaconData.substring(startIndex, startIndex + 20);
      final instance = event.beaconData.substring(
        startIndex + 20,
        startIndex + 32,
      );
      final beaconId = '$namespace.$instance';
      final msg = 'Beacon detected $beaconId | RSSI: ${event.rssi}';

      // if (beaconData.substring(22, 24) != '20') {
      //   log('No voltage $msg');
      //   return;
      // }

      await _checkBatteryVoltage(
        int.tryParse(
          event.beaconData.substring(26, 30),
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
      LoggingInfo.instance.error(
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
    String? goalId,
  }) async {
    if (state.status == GiveStatus.readyToGive) {
      return;
    }
    final organisation = await _getOrganisation(namespace);
    final transactionList = _createTransationList(
      mediumId: namespace,
      guid: userGUID,
      goalId: goalId,
    );

    await _campaignRepository.saveLastDonation(
      organisation,
    );

    var transactionIds = <int>[];
    try {
      LoggingInfo.instance.info('Submitting Givts');
      transactionIds = await _givtRepository.submitGivts(
        guid: userGUID,
        body: {'donations': GivtTransaction.toJsonList(transactionList)},
      );
      await _handleAutoFavorites(namespace, userGUID);
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
      _handleGivtServerFailure(e, stackTrace, emit);
    }

    emit(
      state.copyWith(
        status: GiveStatus.readyToGive,
        organisation: organisation,
        givtTransactions: transactionList,
        transactionIds: transactionIds,
      ),
    );
  }

  void _handleGivtServerFailure(
    GivtServerFailure e,
    StackTrace stackTrace,
    Emitter<GiveState> emit,
  ) {
    final statusCode = e.statusCode;
    final body = e.body;
    log('StatusCode:$statusCode Body:$body');
    LoggingInfo.instance.warning(
      body.toString(),
      methodName: stackTrace.toString(),
    );
    if (statusCode == 417) {
      emit(
        state.copyWith(
          status: GiveStatus.donatedToSameOrganisationInLessThan30Seconds,
        ),
      );
      return;
    }
    emit(
      state.copyWith(status: GiveStatus.error),
    );
    return;
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
    LoggingInfo.instance.info(msg);
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
      LoggingInfo.instance.info(
        'QR Code scanned out of app ${event.encodedMediumId}',
      );
      final mediumId = utf8.decode(base64.decode(event.encodedMediumId));

      await _checkQRCode(mediumId: mediumId, emit: emit);

      if (state.status == GiveStatus.beaconNotActive ||
          state.status == GiveStatus.error) {
        return;
      }

      // Check if amount parameter is present and valid
      double? firstCollectionAmount;
      if (event.amount.isNotEmpty) {
        try {
          final parsedAmount = double.tryParse(
            event.amount.replaceAll(',', '.'),
          );
          if (parsedAmount != null && parsedAmount > 0) {
            firstCollectionAmount = parsedAmount;
            LoggingInfo.instance.info(
              'Using amount from QR code: $firstCollectionAmount',
            );
          }
        } catch (e) {
          LoggingInfo.instance.warning(
            'Failed to parse amount from QR code: ${event.amount}',
          );
        }
      }

      // Update state with the scanned amount if available
      // Using tempAmount instead of firstCollection to hide it until confirmation
      if (firstCollectionAmount != null) {
        emit(
          state.copyWith(
            tempAmount: firstCollectionAmount,
            firstCollection: 0,
            secondCollection: 0,
            thirdCollection: 0,
          ),
        );
      }

      final organisation = await _getOrganisation(mediumId);
      final transactionList = _createTransationList(
        mediumId: mediumId,
        guid: event.userGUID,
        collections: [
          0,
          0,
          0,
        ],
      );

      // Preserve instanceName that was set by _checkQRCode
      final currentInstanceName = state.instanceName;

      LoggingInfo.instance.info(
        'QR Code scanned - orgName: ${organisation.organisationName}, '
        'mediumId: ${organisation.mediumId}, '
        'instanceName: $currentInstanceName, '
        'transactionsCreated: ${transactionList.length}, '
        'userGUID: ${event.userGUID}',
      );

      emit(
        state.copyWith(
          status: GiveStatus.readyToConfirm,
          organisation: organisation,
          givtTransactions: transactionList,
          instanceName: currentInstanceName, // Preserve instanceName
          afterGivingRedirection: event.afterGivingRedirection,
          userGUID:
              event.userGUID, // Store userGUID for later use in amount changes
        ),
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
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
    // Capture organisation and other important state BEFORE any emits
    final currentOrganisation = state.organisation;
    final currentTransactions = state.givtTransactions;
    final currentInstanceName = state.instanceName;
    final currentAfterGivingRedirection = state.afterGivingRedirection;

    LoggingInfo.instance.info(
      'Confirming QR code - orgName: ${currentOrganisation.organisationName}, '
      'mediumId: ${currentOrganisation.mediumId}, '
      'hasTransactions: ${currentTransactions.isNotEmpty}',
    );

    emit(
      state.copyWith(
        status: GiveStatus.loading,
        organisation: currentOrganisation, // Explicitly preserve organisation
      ),
    );

    final confirmedAmount = state.tempAmount;
    final userGUID = state.userGUID;

    await _campaignRepository.saveLastDonation(
      currentOrganisation.copyWith(
        mediumId: currentOrganisation.mediumId,
      ),
    );

    // If skipSubmission is true, just prepare the state without submitting
    // This allows the user to change amounts before final submission
    // Preserve transactions and organisation so they can be updated when amounts change
    if (event.skipSubmission) {
      // If we have a tempAmount, apply it to firstCollection and recreate transactions
      var finalTransactions = currentTransactions;
      var firstCollection = state.collections[0];

      if (confirmedAmount != null && confirmedAmount > 0) {
        firstCollection = confirmedAmount;
        finalTransactions = _createTransationList(
          mediumId: currentOrganisation.mediumId ?? '',
          guid: userGUID,
          collections: [
            confirmedAmount,
            state.collections[1],
            state.collections[2],
          ],
        );
        LoggingInfo.instance.info(
          'Applying tempAmount $confirmedAmount to firstCollection on confirmation',
        );
      }

      final newState = state.copyWith(
        status: GiveStatus.readyToGive,
        organisation: currentOrganisation,
        givtTransactions: finalTransactions,
        firstCollection: firstCollection,
        instanceName: currentInstanceName,
        afterGivingRedirection: currentAfterGivingRedirection,
        tempAmount: 0, // Reset tempAmount after using it
      );

      emit(newState);

      LoggingInfo.instance.info(
        'QR confirmed with skipSubmission - '
        'captured orgName: ${currentOrganisation.organisationName}, '
        'captured mediumId: ${currentOrganisation.mediumId}, '
        'emitted orgName: ${newState.organisation.organisationName}, '
        'emitted mediumId: ${newState.organisation.mediumId}, '
        'hasTransactions: ${currentTransactions.isNotEmpty}, '
        'transactionCount: ${currentTransactions.length}, '
        'userGUID: ${newState.userGUID}, '
        'status: readyToGive',
      );
      return;
    }

    try {
      await _givtRepository.submitGivts(
        guid: state.givtTransactions.first.guid,
        body: {'donations': GivtTransaction.toJsonList(state.givtTransactions)},
      );
      emit(state.copyWith(status: GiveStatus.readyToGive));
    } on SocketException catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: GiveStatus.noInternetConnection,
        ),
      );
      return;
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
    }
  }

  FutureOr<void> _submitTransactions(
    GiveSubmitTransactions event,
    Emitter<GiveState> emit,
  ) async {
    if (state.givtTransactions.isEmpty) {
      return;
    }

    if (state.transactionIds.isNotEmpty) {
      // Already submitted
      return;
    }

    // Capture organisation and transactions before any emits
    final currentOrganisation = state.organisation;
    final currentTransactions = state.givtTransactions;
    final currentInstanceName = state.instanceName;
    final currentAfterGivingRedirection = state.afterGivingRedirection;

    LoggingInfo.instance.info(
      'Submitting transactions - orgName: ${currentOrganisation.organisationName}, '
      'mediumId: ${currentOrganisation.mediumId}, '
      'transactions: ${currentTransactions.length}',
    );

    emit(
      state.copyWith(
        status: GiveStatus.loading,
        organisation: currentOrganisation, // Preserve organisation
      ),
    );

    try {
      final userGUID = currentTransactions.first.guid;
      final mediumId = currentOrganisation.mediumId ?? '';

      final transactionIds = await _givtRepository.submitGivts(
        guid: userGUID,
        body: {'donations': GivtTransaction.toJsonList(currentTransactions)},
      );

      if (mediumId.isNotEmpty) {
        await _handleAutoFavorites(mediumId, userGUID);
      }

      emit(
        state.copyWith(
          status: GiveStatus.readyToGive,
          transactionIds: transactionIds,
          organisation: currentOrganisation, // Explicitly preserve organisation
          givtTransactions: currentTransactions, // Preserve transactions
          instanceName: currentInstanceName, // Preserve instance name
          afterGivingRedirection:
              currentAfterGivingRedirection, // Preserve redirect
        ),
      );

      LoggingInfo.instance.info(
        'Transactions submitted - transactionIds: ${transactionIds.length}, '
        'orgName: ${currentOrganisation.organisationName}',
      );
    } on SocketException catch (e, stackTrace) {
      log(e.toString());
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: GiveStatus.noInternetConnection,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      _handleGivtServerFailure(e, stackTrace, emit);
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
          LoggingInfo.instance.info(
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
            LoggingInfo.instance.info(
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
      } else {
        //there is no nearest location found, prepare for donation from the list
        emit(state.copyWith(status: GiveStatus.success));
      }
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
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
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  /// Search for the beacon that belongs to the given [mediumId]
  /// and return the instanceName that belongs to the beacon
  Future<QrCode> _getCollectGroupInstanceName(String mediumId) async {
    final collectGroupList = await _collectGroupRepository
        .getCollectGroupList();
    if (!mediumId.contains('.')) {
      return const QrCode.empty();
    }
    final namespace = mediumId.split('.').first;
    final instance = mediumId.split('.').last;
    final qrCode = collectGroupList
        .where((org) => org.nameSpace.startsWith(namespace))
        .expand((org) => org.qrCodes)
        .firstWhere(
          (element) => element.instance.endsWith(instance),
          orElse: () => const QrCode.empty(),
        );
    return qrCode;
  }

  /// Search for the qrCode that belongs to the given [mediumId]
  Future<void> _checkQRCode({
    required String mediumId,
    required Emitter<GiveState> emit,
  }) async {
    /// if the mediumId is accessed from the link the instanceName
    /// is already known and can be returned and not check
    if (mediumId.split('.').last.contains('b6')) {
      return;
    }
    if (mediumId.split('.').last.startsWith('6')) {
      return;
    }

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

  FutureOr<void> _onStripeRegistrationError(
    GiveStripeRegistrationError event,
    Emitter<GiveState> emit,
  ) {
    emit(state.copyWith(status: GiveStatus.error));
  }

  FutureOr<void> _onGiveReset(
    GiveReset event,
    Emitter<GiveState> emit,
  ) {
    emit(const GiveState());
  }

  /// Tracks donations to organizations and automatically adds an organization to favorites
  /// after a user gives to the same organization twice in a row (consecutive donations)
  Future<void> _handleAutoFavorites(String namespace, String userGUID) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get previous donation organization
      final previousDonationKey = '${Util.previousDonationOrgKey}_$userGUID';
      final previousDonationOrg = prefs.getString(previousDonationKey) ?? '';

      // Check if this is a consecutive donation to the same organization
      final isConsecutiveDonation = namespace == previousDonationOrg;

      // If this is the second consecutive donation to the same organization, add it to favorites
      if (isConsecutiveDonation && previousDonationOrg.isNotEmpty) {
        // Get favorited organizations
        final favoritesKey = '${Util.favoritedOrganisationsKey}$userGUID';
        final favoritedOrganisations = prefs.getStringList(favoritesKey) ?? [];

        // Only add to favorites if it's not already a favorite
        if (!favoritedOrganisations.contains(namespace)) {
          // Add to favorites
          favoritedOrganisations.add(namespace);
          await prefs.setStringList(favoritesKey, favoritedOrganisations);

          // Get organization name for analytics
          final collectGroupList = await _collectGroupRepository
              .getCollectGroupList();
          final orgName = collectGroupList
              .firstWhere(
                (org) => org.nameSpace == namespace,
                orElse: () => const CollectGroup.empty(),
              )
              .orgName;

          // Log the auto-favorite action
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.favoriteAutoAdded,
            eventProperties: {
              'organisation_name': orgName,
              'organisation_namespace': namespace,
            },
          );
        }
      }

      // Save current organization as the previous one for next time
      await prefs.setString(previousDonationKey, namespace);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        'Error in auto-favorites: $e',
        methodName: stackTrace.toString(),
      );
    }
  }
}
