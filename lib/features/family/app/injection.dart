import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/admin_fee/application/admin_fee_cubit.dart';
import 'package:givt_app/features/family/features/admin_fee/data/repositories/admin_fee_repository.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app/features/family/features/background_audio/bloc/background_audio_cubit.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/mission_acceptance_cubit.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/setup_bedtime_cubit.dart';
import 'package:givt_app/features/family/features/box_origin/bloc/box_origin_cubit.dart';
import 'package:givt_app/features/family/features/edit_child_profile/repositories/edit_profile_repository.dart';
import 'package:givt_app/features/family/features/game_summary/cubit/game_summaries_cubit.dart';
import 'package:givt_app/features/family/features/game_summary/data/game_summaries_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/repositories/organisation_details_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/parent_summary_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/parent_summary_repository.dart';
import 'package:givt_app/features/family/features/gratitude_goal/bloc/gratitude_goal_commit_cubit.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/repositories/gratitude_goal_repository.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_repository/history_repository.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/family_home_screen_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/gratitude_goal_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/repository/impact_groups_repository.dart';
import 'package:givt_app/features/family/features/league/bloc/league_cubit.dart';
import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/login/cubit/family_login_cubit.dart';
import 'package:givt_app/features/family/features/missions/bloc/missions_cubit.dart';
import 'package:givt_app/features/family/features/missions/bloc/notif_mission_cubit.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository_impl.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/give_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_roles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/generous_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/gratitude_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/leave_game_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/stage_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository_impl.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/registration/cubit/us_signup_cubit.dart';
import 'package:givt_app/features/family/features/remote_config/domain/remote_config_repository.dart';
import 'package:givt_app/features/family/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/repositories/reset_password_repository.dart';
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/family/helpers/svg_manager.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/features/splash/cubit/splash_cubit.dart';

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
      () => InternetConnectionCubit(getIt()),
    )
    ..registerFactory(() => StageCubit(getIt()))
    ..registerFactory(ParentSummaryCubit.new)
    ..registerFactory(FunBottomSheetWithAsyncActionCubit.new)
    ..registerFactory(() => GratitudeGoalCubit(getIt()))
    ..registerFactory(() => AdminFeeCubit(getIt()))
    ..registerFactory(() => LeaveGameCubit(getIt()))
    ..registerFactory(() => GratefulCubit(getIt(), getIt(), getIt()))
    ..registerLazySingleton<InterviewCubit>(
      () => InterviewCubit(getIt()),
    )
    ..registerFactory(() => SetupBedtimeCubit(getIt(), getIt()))
    ..registerFactory<GratitudeSelectionCubit>(
      () => GratitudeSelectionCubit(getIt()),
    )
    ..registerLazySingleton<CameraCubit>(
      CameraCubit.new,
    )
    ..registerLazySingleton<MediumCubit>(MediumCubit.new)
    ..registerLazySingleton(() => LeagueCubit(getIt(), getIt(), getIt()))
    ..registerLazySingleton<GiveCubit>(
      () => GiveCubit(
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
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<AvatarsCubit>(
      () => AvatarsCubit(
        getIt(),
      ),
    )
    ..registerFactory(MissionAcceptanceCubit.new)
    ..registerFactory<GenerousSelectionCubit>(
      () => GenerousSelectionCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton<ResetPasswordCubit>(
      () => ResetPasswordCubit(
        getIt(),
      ),
    )
    ..registerLazySingleton<BoxOriginCubit>(
      () => BoxOriginCubit(getIt()),
    )
    ..registerLazySingleton<FamilyAuthCubit>(
      () => FamilyAuthCubit(getIt()),
    )
    ..registerLazySingleton<RecordCubit>(
          RecordCubit.new,
    )
    ..registerLazySingleton<FamilyLoginCubit>(
      () => FamilyLoginCubit(getIt()),
    )
    ..registerFactory<UsSignupCubit>(
      () => UsSignupCubit(getIt(), getIt()),
    )
    ..registerFactory<MissionsCubit>(
      () => MissionsCubit(getIt()),
    )
    ..registerFactory<NotificationMissionsCubit>(
      () => NotificationMissionsCubit(getIt()),
    )
    ..registerFactory<GratitudeGoalCommitCubit>(
      () => GratitudeGoalCommitCubit(getIt(), getIt(), getIt()),
    )
    ..registerFactory<GameSummariesCubit>(
      GameSummariesCubit.new,
    )
    ..registerFactory<BackgroundAudioCubit>(
      () => BackgroundAudioCubit(
        getIt(),
        getIt(),
      ),
    )
    ..registerFactory<SplashCubit>(
      () => SplashCubit(getIt(), getIt(), getIt()),
    );
}

void initRepositories() {
  getIt
    ..registerSingleton<AdminFeeRepository>(
      AdminFeeRepository(
        getIt(),
      ),
    )
    ..registerLazySingleton<LeagueRepository>(
      () => LeagueRepository(getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton<GratitudeGoalRepository>(
      () => GratitudeGoalRepository(getIt()),
    )
    ..registerSingleton<TutorialRepository>(
      TutorialRepository(),
    )
    ..registerSingleton<ParentSummaryRepository>(
      ParentSummaryRepository(
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
    ..registerSingleton<AvatarsRepository>(
      AvatarsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<SvgAssetLoaderManager>(
      SvgAssetLoaderManager.new,
    )
    ..registerLazySingleton<EditChildProfileRepository>(
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
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<RemoteConfigRepository>(
      RemoteConfigRepository.new,
    )
    ..registerLazySingleton<GameSummariesRepository>(
      () => GameSummariesRepository(
        getIt(),
      ),
    )
    ..registerLazySingleton<ResetPasswordRepository>(
      () => ResetPasswordRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<MissionRepository>(
      () => MissionRepositoryImpl(
        getIt(),
        getIt(),
        getIt(),
      ),
    );
}
