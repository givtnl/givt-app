import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/repositories/infra_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'infra_state.dart';

class InfraCubit extends Cubit<InfraState> {
  InfraCubit(this.infraRepository) : super(const InfraInitial());

  final InfraRepository infraRepository;

  Future<void> contactSupport({
    required String guid,
    required String email,
    required String message,
    required String appLanguage,
  }) async {
    emit(const InfraLoading());
    try {
      message = message.replaceAll('\n', '<br>');
      final applang = 'App Language : $appLanguage';
      final info = await PackageInfo.fromPlatform();

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      var os = 'Operating system : $release (SDK $sdkInt)';
      var device = 'Device : $manufacturer $model';

      if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        final systemName = iosInfo.systemName;
        final version = iosInfo.systemVersion;
        final name = iosInfo.name;
        final model = iosInfo.model;
        os = 'Operating system : iOS $systemName $version';
        device = 'Device : $name $model';
      }

      final appversion = 'App version : ${info.version}.${info.buildNumber}';
      final footer =
          '$email<br />$appversion<br />$os<br />$device<br />$applang';

      await infraRepository.contactSupport(
        guid: guid,
        message: '$message <br /><br />$footer',
      );
      emit(const InfraSuccess());
    } catch (e) {
      log(e.toString());
      emit(const InfraFailure());
    }
  }
}
