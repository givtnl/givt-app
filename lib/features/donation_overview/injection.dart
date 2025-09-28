import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/shared/repositories/family_group_repository.dart';

void registerDonationOverviewDependencies() {
  // Repositories
  getIt.registerLazySingleton<DonationOverviewRepository>(
    () => DonationOverviewRepositoryImpl(
      getIt(),
      getIt<FamilyGroupRepository>(),
    ),
  );
  
  // Cubits
  getIt.registerFactory<DonationOverviewCubit>(
    () => DonationOverviewCubit(
      getIt<DonationOverviewRepository>(),
      getIt<FamilyGroupRepository>(),
    ),
  );
}
