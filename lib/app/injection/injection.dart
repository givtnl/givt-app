import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/repositories.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _initCoreDependencies();
  await _initAPIService();

  /// Init repositories
  _initRepositories();
}

Future<void> _initAPIService() async {
  var baseUrl = const String.fromEnvironment('API_URL_EU');
  if (await getIt<CountryIsoInfo>().checkCountryIso == Country.us.countryCode) {
    baseUrl = const String.fromEnvironment('API_URL_US');
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
    ..registerLazySingleton<CountryIsoInfo>(
      CountryIsoInfoImpl.new,
    )
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
    )
    ..registerLazySingleton<InfraRepository>(
      () => InfraRepositoryImpl(
        getIt(),
      ),
    );
}
