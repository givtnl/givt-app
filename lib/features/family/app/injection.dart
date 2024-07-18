import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/admin_fee/application/admin_fee_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/data/repositories/admin_fee_repository.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app/features/family/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/repositories/organisation_details_repository.dart';
import 'package:givt_app/features/family/features/history/history_repository/history_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/repository/impact_groups_repository.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app/features/family/helpers/svg_manager.dart';
import 'package:givt_app/features/family/network/api_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;
  await initAPIService();

  /// Init repositories
  initRepositories();
  initCubits();
}

Future<void> initAPIService() async {
  getIt.registerLazySingleton<FamilyAPIService>(
    () => FamilyAPIService(getIt<RequestHelper>()),
  );
}

void initCubits() {
  getIt.registerFactory(() => AdminFeeCubit(getIt()));
}

void initRepositories() {
  getIt
    ..registerSingleton<AdminFeeRepository>(
      AdminFeeRepository(
        getIt(),
      ),
    )
    ..registerLazySingleton<ProfilesRepository>(
      () => ProfilesRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<OrganisationDetailsRepository>(
      () => OrganisationDetailsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<CreateTransactionRepository>(
      () => CreateTransactionRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<TagsRepository>(
      () => TagsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<OrganisationsRepository>(
      () => OrganisationsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<SvgAssetLoaderManager>(
      SvgAssetLoaderManager.new,
    )
    ..registerLazySingleton<AvatarsRepository>(
      () => AvatarsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<EditProfileRepository>(
      () => EditProfileRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ImpactGroupsRepository>(
      () => ImpactGroupsRepositoryImpl(
        getIt(),
      ),
    );
}
