import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/avatars/repositories/avatars_repository.dart';
import 'package:givt_app/features/family/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/repositories/organisation_details_repository.dart';
import 'package:givt_app/features/family/features/history/history_logic/history_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/repository/impact_groups_repository.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app/features/family/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app/features/family/helpers/svg_manager.dart';
import 'package:givt_app/features/family/network/api_service.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await initAPIService();

  /// Init repositories
  initRepositories();
}

Future<void> initAPIService() async {
  getIt.allowReassignment = true;
  var baseUrl = const String.fromEnvironment('API_URL_EU');
  var baseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');
  final country = await _checkCountry();
  if (country == Country.us.countryCode) {
    baseUrl = const String.fromEnvironment('API_URL_US');
    baseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
  }
  log('Using API URL: $baseUrl');
  if (Platform.isAndroid) {
    final data = await PlatformAssetBundle().load('assets/family/ca/isrgrootx1.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
      data.buffer.asUint8List(),
    );
  }
  getIt.registerLazySingleton<APIService>(
    () => APIService(
      apiURL: baseUrl,
      apiURLAWS: baseUrlAWS,
    ),
  );
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

void initRepositories() {
  getIt.allowReassignment = true;

  getIt
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

  ;
}
