import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:intl/intl.dart';

part 'give_event.dart';
part 'give_state.dart';

class GiveBloc extends Bloc<GiveEvent, GiveState> {
  GiveBloc(this._campaignRepository) : super(const GiveState()) {
    on<GiveQRCodeScanned>(_qrCodeScanned);

    on<GiveAmountChanged>(_amountChanged);
  }

  final CampaignRepository _campaignRepository;

  FutureOr<void> _qrCodeScanned(
    GiveQRCodeScanned event,
    Emitter<GiveState> emit,
  ) async {
    emit(state.copyWith(status: GiveStatus.loading));
    try {
      final uri = Uri.parse(event.rawValue);
      final mediumId = utf8.decode(base64.decode(uri.queryParameters['code']!));
      final organisation = await getOrganisation(mediumId);
      final transactionList = createTransationList(mediumId, event.userGUID);
      final givt = {
        'advertisementImageUrl': '',
        'nativeAppScheme': 'givt:\/\/',
        'YesSuccess': '',
        'Thanks': '',
        'Close': '',
        'GUID': event.userGUID,
        'Collect': '',
        'ConfirmBtn': '',
        'currency': '',
        'isProduction': false,
        'SlimPayInformationPart2': '',
        'advertisementText': '',
        'SlimPayInformation': '',
        'organisation': organisation.organisationName,
        'shouldShowCreditCard': false,
        'ShareGivt': '',
        'urlPart': '',
        'spUrl': '',
        'Cancel': '',
        'message': '',
        'AreYouSureToCancelGivts': '',
        'advertisementTitle': '',
        'apiUrl': '',
        'canShare': false,
        'givtObj': GivtTransaction.toJsonList(transactionList),
      };
      emit(
        state.copyWith(
          status: GiveStatus.success,
          organisation: organisation,
          givt: jsonEncode(givt),
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GiveStatus.error));
    }
  }

  List<GivtTransaction> createTransationList(String mediumId, String guid) {
    final transactionList = <GivtTransaction>[];
    final now = DateTime.now();
    final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SS0").format(now);
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

  Future<Organisation> getOrganisation(String mediumId) async {
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
}
