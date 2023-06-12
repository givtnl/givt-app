import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/give/repositories/beacon_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _initCoreDependencies();

  /// Init repositories
  _initRepositories();
}

Future<void> _initCoreDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        getIt(),
      ),
    );
}

void _initRepositories() {
  getIt
    ..registerLazySingleton<APIService>(
      APIService.new,
    )
    ..registerLazySingleton(
      () => AuthRepositoy(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => CampaignRepository(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => CollectGroupRepository(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => GivtRepository(
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => BeaconRepository(
        getIt(),
      ),
    );
}
