import 'package:get_it/get_it.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton(() => sharedPreferences)
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
      ),
    )
    ..registerLazySingleton(
      () => CollectGroupRepository(
        getIt(),
        getIt(),
      ),
    );
}
