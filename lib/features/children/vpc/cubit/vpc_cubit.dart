import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/vpc/models/vps_response.dart';
import 'package:givt_app/features/children/vpc/repositories/vpc_repository.dart';
import 'package:givt_app/utils/utils.dart';

part 'vpc_state.dart';

class VPCCubit extends Cubit<VPCState> {
  VPCCubit(this._vpcRepository) : super(VPCInitialState());

  final VPCRepository _vpcRepository;

  var _vpcGained = false;

  bool get vpcGained => _vpcGained;

  Future<void> fetchURL(String guid) async {
    emit(VPCFetchingURLState());
    try {
      final response =
          await _vpcRepository.getVerifiableParentalConsentURL(guid);
      emit(VPCWebViewState(response: response));
    } catch (error) {
      emit(VPCErrorState(error: error.toString()));
    }
  }

  void showVPCInfo() {
    emit(VPCInfoState());
  }

  void resetVPC() {
    emit(VPCInitialState());
  }

  void redirectOnSuccess() {
    if (state is VPCWebViewState) {
      AnalyticsHelper.logEvent(eventName: AmplitudeEvents.vpcSuccess);
      emit(VPCSuccessState(response: (state as VPCWebViewState).response));
      _vpcGained = true;
    }
  }

  void redirectOnCancel() {
    if (state is VPCWebViewState) {
      emit(VPCCanceledState(response: (state as VPCWebViewState).response));
    }
  }

  void resetWebView() {
    if (state is VPCCanceledState) {
      AnalyticsHelper.logEvent(eventName: AmplitudeEvents.vpcCancelled);
      emit(VPCWebViewState(response: (state as VPCWebViewState).response));
    }
  }
}
