import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/personal_summary/cubit/personal_summary_cubit.dart';
import 'package:givt_app/features/personal_summary/models/models.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/giving_goal_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class _UnusedGivtRepository with GivtRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedGivingGoalRepository with GivingGoalRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedCollectGroupRepository with CollectGroupRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PersonalSummaryCubit history navigation', () {
    late PersonalSummaryCubit cubit;

    setUp(() {
      cubit = PersonalSummaryCubit(
        _UnusedGivtRepository(),
        _UnusedGivingGoalRepository(),
        _UnusedCollectGroupRepository(),
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    test('category, type, and source taps use the selected year', () async {
      final year = DateTime.now().year;

      final category = await _openHistory(
        cubit,
        () => cubit.openHistoryForCategory(GivingCategory.charity),
      );
      expect(category.categories, {DonationHistoryCategoryFilter.charity});
      expect(category.startDate, DateTime(year));
      expect(category.endDate, DateTime(year, 12, 31));

      final type = await _openHistory(
        cubit,
        () => cubit.openHistoryForDonationType(recurring: true),
      );
      expect(type.type, DonationHistoryTypeFilter.recurring);
      expect(type.startDate, DateTime(year));
      expect(type.endDate, DateTime(year, 12, 31));

      final source = await _openHistory(
        cubit,
        () => cubit.openHistoryForSource(givtProcessed: false),
      );
      expect(source.source, DonationHistorySourceFilter.external);
      expect(source.startDate, DateTime(year));
      expect(source.endDate, DateTime(year, 12, 31));
    });

    test('a selected month still wins over the full year', () async {
      final year = DateTime.now().year;
      cubit.toggleMonth(3);

      final filters = await _openHistory(
        cubit,
        () => cubit.openHistoryForCategory(GivingCategory.church),
      );

      expect(filters.categories, {DonationHistoryCategoryFilter.church});
      expect(filters.startDate, DateTime(year, 3));
      expect(filters.endDate, DateTime(year, 3, 31));
    });
  });
}

Future<DonationHistoryFilters> _openHistory(
  PersonalSummaryCubit cubit,
  void Function() open,
) async {
  final emitted = <BaseState<PersonalSummaryUIModel, PersonalSummaryCustom>>[];
  final subscription = cubit.stream.listen(emitted.add);
  open();
  await Future<void>.delayed(Duration.zero);
  await subscription.cancel();
  final custom = emitted
      .whereType<CustomState<PersonalSummaryUIModel, PersonalSummaryCustom>>()
      .last
      .custom;
  return (custom as NavigateToDonationHistory).filters;
}
