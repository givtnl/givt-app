import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/personal_summary/cubit/personal_summary_cubit.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/giving_goal_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

void registerPersonalSummaryDependencies() {
  getIt.registerFactory<PersonalSummaryCubit>(
    () => PersonalSummaryCubit(
      getIt<GivtRepository>(),
      getIt<GivingGoalRepository>(),
      getIt<CollectGroupRepository>(),
    ),
  );
}
