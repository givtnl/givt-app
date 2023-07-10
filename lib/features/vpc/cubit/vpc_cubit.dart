import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/vpc/models/vps_response.dart';
import 'package:givt_app/features/vpc/repositories/vpc_repository.dart';

part 'vpc_state.dart';

class VPCCubit extends Cubit<VPCState> {
  VPCCubit(this._vpcRepository) : super(VPCProfilesOverview());

  final VPCRepository _vpcRepository;

  Future<void> fetchURL(String email) async {
    emit(VPCFetchingURLState());
    try {
      final response =
          await _vpcRepository.getVerifiableParentalConsentURL(email);
      emit(VPCWebViewState(response: response));
    } catch (error) {
      emit(VPCErrorState(error: error.toString()));
    }
  }

  void showVPCInfo() {
    emit(VPCInfoState());
  }

  void redirectOnSuccess() {
    if (state is VPCWebViewState) {
      emit(VPCSuccessState(response: (state as VPCWebViewState).response));
    }
  }

  void redirectOnCancel() {
    if (state is VPCWebViewState) {
      emit(VPCCanceledState(response: (state as VPCWebViewState).response));
    }
  }

  void resetWebView() {
    if (state is VPCCanceledState) {
      emit(VPCWebViewState(response: (state as VPCWebViewState).response));
    }
  }
}
