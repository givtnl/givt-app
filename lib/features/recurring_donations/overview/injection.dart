import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_overview_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

void registerRecurringDonationsOverviewDependencies() {
  // Repositories
  getIt.registerLazySingleton<RecurringDonationsOverviewRepository>(
    () => RecurringDonationsOverviewRepositoryImpl(
      getIt<APIService>(),
      getIt<CollectGroupRepository>(),
    ),
  );
  
  // Cubits
  getIt.registerFactory<RecurringDonationsOverviewCubit>(
    () => RecurringDonationsOverviewCubit(
      getIt<RecurringDonationsOverviewRepository>(),
    ),
  );
}
