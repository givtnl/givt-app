import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/eu/cubit/eu_profiles_cubit.dart';
import 'package:givt_app/features/eu/repository/eu_profiles_repository.dart';

void registerEuDependencies() {
  // Register repositories
  getIt.registerLazySingleton<EuProfilesRepository>(
    () => EuProfilesRepositoryImpl(getIt<AuthRepository>()),
  );

  // Register cubits
  getIt.registerFactory<EuProfilesCubit>(
    () => EuProfilesCubit(
      getIt<EuProfilesRepository>(),
      getIt<AuthRepository>(),
    ),
  );
}