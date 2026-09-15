import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/external_donation_history_detail_cubit.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

void registerDonationOverviewDependencies() {
  // Repositories
  getIt.registerLazySingleton<DonationOverviewRepository>(
    () => DonationOverviewRepositoryImpl(
      getIt<GivtRepository>(),
      getIt<CollectGroupRepository>(),
    ),
  );

  // Cubits
  getIt.registerFactory<DonationOverviewCubit>(
    () => DonationOverviewCubit(
      getIt<DonationOverviewRepository>(),
    ),
  );
  getIt.registerFactory<ExternalDonationHistoryDetailCubit>(
    () => ExternalDonationHistoryDetailCubit(
      getIt(),
    ),
  );
}
