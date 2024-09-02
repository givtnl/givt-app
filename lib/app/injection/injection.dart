import 'dart:convert';
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/children/edit_profile/repositories/edit_parent_profile_repository.dart';
import 'package:givt_app/features/children/family_goal/repositories/create_family_goal_repository.dart';
import 'package:givt_app/features/children/family_history/repository/family_history_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/chat_scripts_asset_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/chat_scripts_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_vpc_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_history_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/utils/chat_script_registration_handler.dart';
import 'package:givt_app/features/children/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/features/recurring_donations/cancel/repositories/cancel_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/create/repositories/create_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/detail/repository/detail_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_repository.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:givt_app/utils/media_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _initCoreDependencies();
  await _initRequestHelper();
  await initAPIService();

  /// Init repositories
  initRepositories();
}

Future<void> initAPIService() async {
  getIt.allowReassignment = true;
  getIt.registerLazySingleton<APIService>(
    () => APIService(
      getIt<RequestHelper>(),
    ),
  );
}

Future<RequestHelper> _initRequestHelper() async {
  var baseUrl = const String.fromEnvironment('API_URL_EU');
  var baseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');
  final country = await _checkCountry();
  if (country == Country.us.countryCode) {
    baseUrl = const String.fromEnvironment('API_URL_US');
    baseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
  }
  log('Using API URL: $baseUrl');
  final requestHelper =
      RequestHelper(getIt(), getIt(), apiURL: baseUrl, apiURLAWS: baseUrlAWS);
  await requestHelper.init();
  getIt.registerSingleton<RequestHelper>(requestHelper);
  return requestHelper;
}

/// Check if there is a user extension set in the shared preferences.
/// If there is, return the country of the user extension.
/// If there is not, return a default country (NL).
Future<String> _checkCountry() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(UserExt.tag)) {
    final userExtString = prefs.getString(UserExt.tag);
    if (userExtString != null) {
      final user =
          UserExt.fromJson(jsonDecode(userExtString) as Map<String, dynamic>);
      return user.country;
    }
  }

  return Country.nl.countryCode;
}

Future<void> _initCoreDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton(AppConfig())
    ..registerLazySingleton(InternetConnection.new)
    ..registerLazySingleton(NotificationService.new)
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton<CountryIsoInfo>(
      CountryIsoInfoImpl.new,
    )
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        getIt(),
      ),
    );
}

void initRepositories() {
  getIt.allowReassignment = true;

  getIt
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoyImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ImagePicker>(ImagePicker.new)
    ..registerLazySingleton<MediaPickerService>(
      () => MediaPickerService(getIt()),
    )
    ..registerLazySingleton<CampaignRepository>(
      () => CampaignRepositoryImpl(
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<CollectGroupRepository>(
      () => CollectGroupRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<GivtRepository>(
      () => GivtRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<GivingGoalRepository>(
      () => GivingGoalRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<BeaconRepository>(
      () => BeaconRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<InfraRepository>(
      () => InfraRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ParentalApprovalRepository>(
      () => ParentalApprovalRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<RecurringDonationsRepository>(
      () => RecurringDonationsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<CancelRecurringDonationRepository>(
      () => CancelRecurringDonationRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<DetailRecurringDonationsRepository>(
      () => DetailRecurringDonationsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<CreateRecurringDonationRepository>(
      () => CreateRecurringDonationRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<FamilyDonationHistoryRepository>(
      () => FamilyDonationHistoryRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<EditChildRepository>(
      () => EditChildRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<AddMemberRepository>(
      () => AddMemberRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<AvatarsRepository>(
      () => AvatarsRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<EditParentProfileRepository>(
      () => EditParentProfileRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<CachedMembersRepository>(
      () => CachedMembersRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<CreateFamilyGoalRepository>(
      () => CreateFamilyGoalRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ImpactGroupsRepository>(
      () => ImpactGroupsRepositoryImpl(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<GenerosityChallengeRepository>(
      () => GenerosityChallengeRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ChatScriptsRepository>(
      ChatScriptsAssetRepositoryImpl.new,
    )
    ..registerLazySingleton<ChatScriptRegistrationHandler>(
      () => ChatScriptRegistrationHandler(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<GenerosityChallengeVpcRepository>(
      () => GenerosityChallengeVpcRepository(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<GenerosityChallengeVpcSetupCubit>(
      () => GenerosityChallengeVpcSetupCubit(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ChatHistoryRepository>(
      () => ChatHistoryRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<AddMemberCubit>(
      () => AddMemberCubit(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<CachedMembersCubit>(
      () => CachedMembersCubit(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<StripeCubit>(
      () => StripeCubit(
        authRepositoy: getIt<AuthRepository>(),
      ),
    );
}
