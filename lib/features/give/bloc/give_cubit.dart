import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';

part 'give_state.dart';

class GiveCubit extends Cubit<GiveState> {
  GiveCubit(this._campaignRepository) : super(GiveInitial());

  final CampaignRepository _campaignRepository;

  Future<void> getOrganization(String rawValue) async {
    emit(GiveLoading());
    try {
      final uri = Uri.parse(rawValue);
      final mediumId = uri.queryParameters['code'];
      final organisation = await _campaignRepository.getOrganisation(mediumId!);
      organisation.copyWith(mediumId: mediumId);

      emit(GiveLoaded(organisation: organisation));
      
    } catch (e) {
      log(e.toString());
      emit(GiveError());
    }
  }
}
