import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class LogMessage extends Equatable {
  LogMessage({
    this.guid,
    this.file,
    this.level,
    this.lnr,
    this.message,
    this.method,
    this.model,
    this.platformID,
    this.tag,
    this.deviceUTCTimestamp,
    this.versionOS,
    this.appVersion,
    this.lang,
    this.deviceId,
    this.correlationId,
  });

  String? guid;
  String? file;
  String? level;
  String? lnr;
  String? message;
  String? method;
  String? model;
  String? platformID;
  String? tag;
  String? deviceUTCTimestamp;
  String? versionOS;
  String? appVersion;
  String? lang;
  String? deviceId;
  String? correlationId;

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'file': file,
        'level': level,
        'lnr': lnr,
        'message': message,
        'method': method,
        'model': model,
        'platformID': platformID,
        'tag': tag,
        'deviceUTCTimestamp': deviceUTCTimestamp,
        'versionOS': versionOS,
        'appVersion': appVersion,
        'lang': lang,
        'deviceId': deviceId,
        'correlation-id': correlationId,
      };

  LogMessage copyWith({
    String? guid,
    String? file,
    String? level,
    String? lnr,
    String? message,
    String? method,
    String? model,
    String? platformID,
    String? tag,
    String? timestamp,
    String? versionOS,
    String? appVersion,
    String? lang,
    String? deviceId,
    String? correlationId,
  }) {
    return LogMessage(
      guid: guid ?? this.guid,
      file: file ?? this.file,
      level: level ?? this.level,
      lnr: lnr ?? this.lnr,
      message: message ?? this.message,
      method: method ?? this.method,
      model: model ?? this.model,
      platformID: platformID ?? this.platformID,
      tag: tag ?? this.tag,
      deviceUTCTimestamp: timestamp ?? deviceUTCTimestamp,
      versionOS: versionOS ?? this.versionOS,
      appVersion: appVersion ?? this.appVersion,
      lang: lang ?? this.lang,
      deviceId: deviceId ?? this.deviceId,
      correlationId: correlationId ?? this.correlationId,
    );
  }

  @override
  List<Object?> get props => [
        guid,
        file,
        level,
        lnr,
        message,
        method,
        model,
        platformID,
        tag,
        deviceUTCTimestamp,
        versionOS,
        appVersion,
        lang,
        deviceId,
        correlationId,
      ];
}
