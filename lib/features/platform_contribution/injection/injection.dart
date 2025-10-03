import 'package:givt_app/features/platform_contribution/data/repositories/platform_contribution_repository_impl.dart';
import 'package:givt_app/features/platform_contribution/domain/repositories/platform_contribution_repository.dart';
import 'package:givt_app/features/platform_contribution/presentation/cubit/platform_contribution_cubit.dart';
import 'package:get_it/get_it.dart';

/// Dependency injection for platform contribution feature
void registerPlatformContributionDependencies() {
  // Repositories
  GetIt.instance.registerLazySingleton<PlatformContributionRepository>(
    () => PlatformContributionRepositoryImpl(),
  );

  // Cubits
  GetIt.instance.registerFactory<PlatformContributionCubit>(
    () => PlatformContributionCubit(
      repository: GetIt.instance<PlatformContributionRepository>(),
    ),
  );
}
