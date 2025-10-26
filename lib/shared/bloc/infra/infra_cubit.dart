import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/infra_repository.dart';
import 'package:ios_utsname_ext/extension.dart';

part 'infra_state.dart';

class InfraCubit extends Cubit<InfraState> {
  InfraCubit(this.infraRepository, this.appConfig)
      : super(const InfraInitial());

  final InfraRepository infraRepository;
  final AppConfig appConfig;

  Future<void> contactSupportSafely({
    required String guid,
    required String email,
    required String message,
    required String appLanguage,
    String? subject,
    String? searchText,
  }) async {
    try {
      await contactSupport(
        guid: guid,
        email: email,
        message: message,
        appLanguage: appLanguage,
        subject: subject,
        searchText: searchText,
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const InfraFailure());
    }
  }

  Future<void> contactSupport({
    required String guid,
    required String email,
    required String message,
    required String appLanguage,
    String? subject,
    String? searchText,
  }) async {
    emit(const InfraLoading());
    message = message.replaceAll('\n', '<br>');
    final applang = 'App Language : $appLanguage';
    final info = appConfig.packageInfo;

    late String os;
    late String device;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      os = 'Operating system : $release (SDK $sdkInt)';
      device = 'Device : $manufacturer $model';
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final machineId = iosInfo.utsname.machine;
      final name = machineId.iOSProductName;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final model = iosInfo.model;
      os = 'Operating system : $systemName $version';
      device = 'Device : $name $model';
    }

    final appversion = 'App version : ${info.version}.${info.buildNumber}';
    final footer =
        '$email<br />$appversion<br />$os<br />$device<br />$applang';

    await infraRepository.contactSupport(
      guid: guid,
      message: '$message <br /><br />$footer',
      subject: subject,
      searchText: searchText,
    );
    emit(const InfraSuccess());
  }

  Future<void> checkForUpdate() async {
    emit(const InfraLoading());
    try {
      final info = appConfig.packageInfo;
      final buildNumber = info.buildNumber;
      final update = await infraRepository.checkAppUpdate(
        buildNumber: buildNumber,
        platform: Platform.isIOS ? '1' : '2',
      );
      if (update == null) {
        emit(const InfraSuccess());
        return;
      }
      emit(
        InfraUpdateAvailable(
          update,
        ),
      );
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const InfraFailure());
    }
  }
}
