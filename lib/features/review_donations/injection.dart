import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/features/review_donations/cubit/review_donations_cubit.dart';

void registerReviewDonationsDependencies() {
  // Cubits
  getIt.registerFactory<ReviewDonationsCubit>(
    () => ReviewDonationsCubit(
      getIt<DonationOverviewRepository>(),
    ),
  );
}
