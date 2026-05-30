import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/repositories/external_donation_detail_repository.dart';
import 'package:givt_app/features/external_donations/overview/cubit/external_donations_overview_cubit.dart';
import 'package:givt_app/features/external_donations/overview/repositories/external_donations_overview_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

void registerExternalDonationsDependencies() {
  getIt
    ..registerLazySingleton<ExternalDonationsOverviewRepository>(
      () => ExternalDonationsOverviewRepositoryImpl(
        getIt<GivtRepository>(),
      ),
    )
    ..registerFactory<ExternalDonationsOverviewCubit>(
      () => ExternalDonationsOverviewCubit(
        getIt<ExternalDonationsOverviewRepository>(),
      ),
    )
    ..registerLazySingleton<ExternalDonationDetailRepository>(
      () => ExternalDonationDetailRepositoryImpl(
        getIt<GivtRepository>(),
      ),
    )
    ..registerFactory<ExternalDonationDetailCubit>(
      () => ExternalDonationDetailCubit(
        getIt<ExternalDonationDetailRepository>(),
      ),
    );
}
