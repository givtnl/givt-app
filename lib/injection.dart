import 'dart:developer';

import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init({
  required Map<String, String> environmentVariables,
}) async {
  await _initAPIService(environmentVariables);
  await _initCoreDependencies();

  /// Init repositories
  _initRepositories();
}

Future<void> _initAPIService(Map<String, String> environmentVariables) async {
  var baseUrl = environmentVariables['API_URL_EU']!;
  try {
    final countryIso = await FlutterSimCountryCode.simCountryCode;
    if (countryIso == 'US') {
      baseUrl = environmentVariables['API_URL_US']!;
    } else {
      baseUrl = environmentVariables['API_URL_EU']!;
    }
  } catch (e) {
    /// This fails when testing on a emulator
    log(e.toString());
  }
  log('Using API URL: $baseUrl');
  getIt.registerLazySingleton<APIService>(
    () => APIService(
      apiURL: baseUrl,
    ),
  );
}

Future<void> _initCoreDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton(InternetConnectionCheckerPlus.new)
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        getIt(),
      ),
    );
}

void _initRepositories() {
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
    );
}
