import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/eu_profile_selection/cubit/eu_profile_selection_cubit.dart';
import 'package:givt_app/features/eu_profile_selection/repository/eu_profile_repository.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerEuProfileSelectionDependencies() {
  // Register repository
  getIt.registerLazySingleton<EuProfileRepository>(
    () => EuProfileRepositoryImpl(
      getIt<SharedPreferences>(),
      getIt<FamilyAPIService>(),
    ),
  );

  // Register cubit
  getIt.registerFactory<EuProfileSelectionCubit>(
    () => EuProfileSelectionCubit(
      getIt<EuProfileRepository>(),
    ),
  );
}
