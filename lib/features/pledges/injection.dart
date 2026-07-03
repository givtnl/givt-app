import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/features/pledges/detail/repositories/pledge_detail_repository.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/features/pledges/overview/cubit/pledges_overview_cubit.dart';
import 'package:givt_app/features/pledges/overview/repositories/pledges_overview_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

void registerPledgesDependencies() {
  getIt
    ..registerLazySingleton<PledgesOverviewRepository>(
      () => PledgesOverviewRepositoryImpl(
        getIt<GivtRepository>(),
      ),
    )
    ..registerFactory<PledgeDetailRepository>(
      () => PledgeDetailRepositoryImpl(
        getIt<GivtRepository>(),
      ),
    )
    ..registerFactory<PledgesOverviewCubit>(
      () => PledgesOverviewCubit(
        getIt<PledgesOverviewRepository>(),
      ),
    )
    ..registerFactory<PledgeDetailCubit>(
      () => PledgeDetailCubit(
        getIt<PledgeDetailRepository>(),
      ),
    )
    ..registerFactory<PledgeManageCubit>(
      () => PledgeManageCubit(
        getIt<PledgeDetailRepository>(),
      ),
    );
}
