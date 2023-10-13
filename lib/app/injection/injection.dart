import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/create_child/repositories/create_child_repository.dart';
import 'package:givt_app/features/children/overview/repositories/children_overview_repository.dart';
import 'package:givt_app/features/children/vpc/repositories/vpc_repository.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/recurring_donations/cancel/repositories/cancel_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/create/repositories/create_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/detail/repository/detail_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _initCoreDependencies();
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
    final data = await PlatformAssetBundle().load('assets/ca/isrgrootx1.pem');
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

Future<void> _initCoreDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton(InternetConnectionCheckerPlus.new)
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
    ..registerLazySingleton<AuthRepositoy>(
      () => AuthRepositoyImpl(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<CampaignRepository>(
      () => CampaignRepositoryImpl(
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
    ..registerLazySingleton<VPCRepository>(
      () => VPCRepositoryImpl(
        getIt(),
      ),
    )
    ..registerLazySingleton<ChildrenOverviewRepository>(
      () => ChildrenOverviewRepositoryImpl(
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
    ..registerLazySingleton<CreateChildRepository>(
      () => CreateChildRepositoryImpl(
        getIt(),
      ),
    );
}
