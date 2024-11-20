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
    } catch (e,s) {
      LoggingInfo.instance
          .error('Failed to fetch summary', methodName: 'fetchSummary');
      _summary = ParentSummaryItem(
        date: DateTime.now(),
        audio: 'https://download.samplelib.com/mp3/sample-3s.mp3',
        conversations: [
          Conversation(
              sentence:
                  "Grateful for nature, I donated \$5 to Make-A-Wish to help make dreams come true.",
              profile: Profile.fromMap(jsonDecode('''
                {
                  "id": "ea04efcc-f9c4-433d-90c3-8df1d14a9625",
                  "firstName": "Debby",
                  "lastName": null,
                  "dateOfBirth": "2019-07-01T00:00:00",
                  "givingAllowance": null,
                  "bedTime": "18:00:00",
                  "windDownTime": 30,
                  "type": "Child",
                  "picture": {
                    "fileName": "Hero1.svg",
                    "pictureURL": "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero7.svg"
                  },
                  "wallet": {
                    "balance": 0.0,
                    "total": 0.0,
                    "pending": 0,
                    "currency": "USD",
                    "pendingAllowance": false,
                    "givingAllowance": {
                      "amount": 0,
                      "nextGivingAllowance": "0001-01-01T00:00:00+00:00",
                      "frequency": "None"
                    }
                  },
                  "latestDonation": null
                }
              ''') as Map<String, dynamic>)),
          Conversation(
              sentence:
              "Grateful for our home, I’m packing a care bag to help someone in need feel cared for.",
              profile: Profile.fromMap(jsonDecode('''
                {
                  "id": "ea04efcc-f9c4-433d-90c3-8df1d14a9625",
                  "firstName": "James",
                  "lastName": null,
                  "dateOfBirth": "2019-07-01T00:00:00",
                  "givingAllowance": null,
                  "bedTime": "18:00:00",
                  "windDownTime": 30,
                  "type": "Child",
                  "picture": {
                    "fileName": "Hero1.svg",
                    "pictureURL": "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero4.svg"
                  },
                  "wallet": {
                    "balance": 0.0,
                    "total": 0.0,
                    "pending": 0,
                    "currency": "USD",
                    "pendingAllowance": false,
                    "givingAllowance": {
                      "amount": 0,
                      "nextGivingAllowance": "0001-01-01T00:00:00+00:00",
                      "frequency": "None"
                    }
                  },
                  "latestDonation": null
                }
              ''') as Map<String, dynamic>)),
        ],
      );
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
