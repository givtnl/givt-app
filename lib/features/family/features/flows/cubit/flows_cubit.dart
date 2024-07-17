import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  FlowsCubit() : super(const FlowsState(flowType: FlowType.none));

  void startDeepLinkCoinFlow() {
    emit(const FlowsState(flowType: FlowType.deepLinkCoin));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', false);
  }

  void startInAppCoinFlow() {
    emit(const FlowsState(flowType: FlowType.inAppCoin));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', true);
  }

  void startInGenerosityCoinFlow() {
    emit(const FlowsState(flowType: FlowType.inAppGenerosityCoin));
  }

  void startInAppQRCodeFlow() {
    emit(const FlowsState(flowType: FlowType.inAppQRCode));
  }

  void startRecommendationFlow() {
    emit(const FlowsState(flowType: FlowType.recommendation));
  }

  void startExhibitionFlow() {
    emit(const FlowsState(flowType: FlowType.exhibition));
  }

  void startFamilyGoalFlow() {
    emit(const FlowsState(flowType: FlowType.familyGoal));
  }

  void resetFlow() {
    emit(const FlowsState(flowType: FlowType.none));
    getIt<SharedPreferences>().setBool('isInAppCoinFlow', false);
  }
}
