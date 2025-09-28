import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/manage_family/cubit/manage_family_cubit.dart';
import 'package:givt_app/features/manage_family/repository/manage_family_repository.dart';
import 'package:givt_app/shared/repositories/family_group_repository.dart';

void registerEuFamilyManagementDependencies() {
  final getIt = GetIt.instance;

  // Repository
  getIt.registerLazySingleton<ManageFamilyRepository>(
    () => FamilyManagementRepositoryImpl(
      getIt<APIService>(),
      getIt<FamilyGroupRepository>(),
    ),
  );

  // Cubit
  getIt.registerFactory<ManageFamilyCubit>(
    () => ManageFamilyCubit(
      getIt<ManageFamilyRepository>(),
    ),
  );
}
