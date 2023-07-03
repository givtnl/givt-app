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
    this.timestamp,
    this.versionOS,
    this.appVersion,
    this.lang,
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
  String? timestamp;
  String? versionOS;
  String? appVersion;
  String? lang;

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
        'timestamp': timestamp,
        'versionOS': versionOS,
        'appVersion': appVersion,
        'lang': lang,
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
      timestamp: timestamp ?? this.timestamp,
      versionOS: versionOS ?? this.versionOS,
      appVersion: appVersion ?? this.appVersion,
      lang: lang ?? this.lang,
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
        timestamp,
        versionOS,
        appVersion,
        lang,
      ];
}
