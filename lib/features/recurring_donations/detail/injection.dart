import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

void registerRecurringDonationDetailDependencies() {
  final getIt = GetIt.instance;

  // Repositories
  getIt.registerLazySingleton<RecurringDonationDetailRepository>(
    () => RecurringDonationDetailRepositoryImpl(
      getIt<APIService>(),
      getIt<CollectGroupRepository>(),
    ),
  );

  // Cubits
  getIt.registerFactory<RecurringDonationDetailCubit>(
    () => RecurringDonationDetailCubit(
      getIt<RecurringDonationDetailRepository>(),
    ),
  );
}
