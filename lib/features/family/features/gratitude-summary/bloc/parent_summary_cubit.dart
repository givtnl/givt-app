import 'dart:convert';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/parent_summary_repository.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ParentSummaryCubit extends CommonCubit<ParentSummaryUIModel?, dynamic> {
  ParentSummaryCubit() : super(const BaseState.loading());

  final ParentSummaryRepository _summaryRepository =
      getIt<ParentSummaryRepository>();

  ParentSummaryItem? _summary;

  void init() {
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    try {
      emitLoading();
      final summary = await _summaryRepository.fetchLatestGameSummary();
      _summary = summary;
    } catch (e, s) {
      LoggingInfo.instance
          .error('Failed to fetch summary', methodName: 'fetchSummary');
    }
    _emitData();
  }

  Future<void> onClickTryAgain() async {
    await fetchSummary();
  }

  void _emitData() {
    emitData(_summary?.toUIModel());
  }
}
