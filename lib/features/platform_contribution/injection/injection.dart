import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/platform_contribution/cubit/platform_contribution_cubit.dart';
import 'package:givt_app/features/platform_contribution/data/repositories/platform_contribution_repository_impl.dart';
import 'package:givt_app/features/platform_contribution/domain/repositories/platform_contribution_repository.dart';

/// Dependency injection for platform contribution feature
void registerPlatformContributionDependencies() {
  // Repositories
  GetIt.instance.registerLazySingleton<PlatformContributionRepository>(
    () => PlatformContributionRepositoryImpl(GetIt.instance<APIService>()),
  );

  // Cubits
  GetIt.instance.registerFactory<PlatformContributionCubit>(
    () => PlatformContributionCubit(
      repository: GetIt.instance<PlatformContributionRepository>(),
    ),
  );
}
