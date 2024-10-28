import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/admin_fee/application/admin_fee_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/data/repositories/admin_fee_repository.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app/features/family/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/repositories/organisation_details_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_repository/history_repository.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/family_home_screen_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/repository/impact_groups_repository.dart';
import 'package:givt_app/features/family/features/login/cubit/family_login_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_roles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/gratitude_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository_impl.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/repositories/reset_password_repository.dart';
import 'package:givt_app/features/family/helpers/svg_manager.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';

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
  getIt
    ..registerLazySingleton<InternetConnectionCubit>(
        () => InternetConnectionCubit(getIt()))
    ..registerFactory(() => AdminFeeCubit(getIt()))
    ..registerFactory(() => GratefulCubit(getIt(), getIt(), getIt()))
    ..registerLazySingleton<InterviewCubit>(
      () => InterviewCubit(getIt()),
    )
    ..registerLazySingleton<GratitudeSelectionCubit>(
      () => GratitudeSelectionCubit(getIt()),
    )
    ..registerLazySingleton<CameraCubit>(
      CameraCubit.new,
    )
    ..registerLazySingleton<MediumCubit>(MediumCubit.new)
    ..registerLazySingleton<GiveBloc>(
      () => GiveBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<OrganisationBloc>(
      () => OrganisationBloc(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(() => HistoryCubit(getIt()))
    ..registerFactory<FamilyRolesCubit>(
      () => FamilyRolesCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton(() => SummaryCubit(getIt()))
    ..registerLazySingleton<NavigationBarHomeCubit>(
      () => NavigationBarHomeCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerFactory<FamilySelectionCubit>(
      () => FamilySelectionCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton<FamilyHomeScreenCubit>(
      () => FamilyHomeScreenCubit(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<AvatarsCubit>(
      () => AvatarsCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton<ResetPasswordCubit>(
      () => ResetPasswordCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton<FamilyAuthCubit>(
      () => FamilyAuthCubit(getIt()),
    )
    ..registerLazySingleton<FamilyLoginCubit>(
      () => FamilyLoginCubit(getIt()),
    );
}

void initRepositories() {
  getIt
    ..registerSingleton<AdminFeeRepository>(
      AdminFeeRepository(
        getIt(),
      ),
    )
    ..registerLazySingleton<FamilyAuthRepository>(
      () => FamilyAuthRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ProfilesRepository>(
      () => ProfilesRepositoryImpl(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
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
    )
    ..registerLazySingleton<GratefulRecommendationsRepository>(
      () => GratefulRecommendationsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ReflectAndShareRepository>(
      () => ReflectAndShareRepository(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ResetPasswordRepository>(
      () => ResetPasswordRepositoryImpl(
        getIt(),
      ),
    );
}
