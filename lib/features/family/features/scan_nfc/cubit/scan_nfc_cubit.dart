import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:nfc_manager/nfc_manager.dart';

part 'scan_nfc_state.dart';

class ScanNfcCubit extends Cubit<ScanNfcState> {
  ScanNfcCubit()
      : super(
          const ScanNfcState(
            scanNFCStatus: ScanNFCStatus.ready,
          ),
        );

  static const animationDuration = Duration(milliseconds: 1000);
  static const debuggingSuccessDelay = Duration(milliseconds: 1000);

  void cancelScanning() {
    NfcManager.instance.stopSession();
    emit(state.copyWith(scanNFCStatus: ScanNFCStatus.ready));
  }

  void stopScanningSession() {
    // for android we try to close session
    if (!Platform.isIOS) {
      NfcManager.instance.stopSession();
    }
  }

  void readTag({Duration prescanningDelay = Duration.zero}) async {
    // Prescanning delay is to improve the UI animation (not be jarring)
    await Future.delayed(prescanningDelay);
    AnalyticsHelper.logEvent(eventName: AmplitudeEvents.startScanningCoin);

    emit(
      state.copyWith(
        scanNFCStatus: ScanNFCStatus.scanning,
      ),
    );
    // Check NFC availability
    final bool isAvailable = await NfcManager.instance.isAvailable();
    //only android bc ios has custom error display
    if (!isAvailable && Platform.isAndroid) {
      await Future.delayed(animationDuration);
      emit(
        state.copyWith(
          scanNFCStatus: ScanNFCStatus.nfcNotAvailable,
        ),
      );
      return;
    }
    // When the device is not a physical device, we can't scan NFC
    // so we simulate a successful scan
    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        Future.delayed(debuggingSuccessDelay, () {
          emit(
            state.copyWith(
              mediumId: OrganisationDetailsCubit.defaultMediumId,
              readData: '',
              scanNFCStatus: ScanNFCStatus.scanned,
            ),
          );
        });
        return;
      }
    }
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        Future.delayed(debuggingSuccessDelay, () {
          emit(
            state.copyWith(
              mediumId: OrganisationDetailsCubit.defaultMediumId,
              readData: '',
              scanNFCStatus: ScanNFCStatus.scanned,
            ),
          );
        });
        return;
      }
    }

    try {
      unawaited(NfcManager.instance.startSession(
        alertMessage: 'Tap your coin to the top\nof the iPhone',
        onError: (error) async {
          log('coin read error: ${error.message}');
          if (error.type != NfcErrorType.systemIsBusy) {
            cancelScanning();
          }
        },
        onDiscovered: (NfcTag tag) async {
          log('coin discovered: ${tag.data}');
          final ndef = Ndef.from(tag);
          if (ndef != null && ndef.cachedMessage != null) {
            if (ndef.cachedMessage!.records.isNotEmpty &&
                ndef.cachedMessage!.records.first.typeNameFormat ==
                    NdefTypeNameFormat.nfcWellknown) {
              String mediumId = '';
              String readData = '';
              final wellKnownRecord = ndef.cachedMessage!.records.first;
              if (wellKnownRecord.payload.first == 0x02) {
                final languageCodeAndContentBytes =
                    wellKnownRecord.payload.skip(1).toList();
                final languageCodeAndContentText =
                    utf8.decode(languageCodeAndContentBytes);
                final payload = languageCodeAndContentText.substring(2);
                log('coin payload: $payload');
                final Uri uri = Uri.parse(payload);
                mediumId = uri.queryParameters['code'] ?? mediumId;
                readData = payload;
              } else {
                final decoded = utf8.decode(wellKnownRecord.payload);
                log('coin decoded: $decoded');
                final Uri uri = Uri.parse(decoded);
                mediumId = uri.queryParameters['code'] ?? mediumId;
                readData = decoded;
              }
              // on Android we intentionally keep session open
              // until user triggers stop scanning on another screen
              if (Platform.isIOS) {
                await NfcManager.instance.stopSession(alertMessage: ' ');
              }

              if (mediumId.isEmpty) {
                _handleException(
                  Exception('NFC coin decoded error, medium ID is empty'),
                );
              } else {
                emit(
                  state.copyWith(
                    mediumId: mediumId,
                    readData: readData,
                    scanNFCStatus: ScanNFCStatus.scanned,
                  ),
                );
              }
            }
          } else {
            _handleException(
              Exception(
                'NFC could not be decoded error, probably not a Givt coin',
              ),
            );
          }
        },
      ));
    } catch (e, stackTrace) {
      _handleException(e, stackTrace: stackTrace);
    }
  }

  void _handleException(Object e, {StackTrace? stackTrace}) {
    LoggingInfo.instance.error(
      'Error while scanning coin: $e',
      methodName: stackTrace.toString(),
    );

    emit(
      state.copyWith(
        scanNFCStatus: ScanNFCStatus.error,
      ),
    );
    NfcManager.instance.stopSession();
    AnalyticsHelper.logEvent(eventName: AmplitudeEvents.coinScannedError);
  }
}
