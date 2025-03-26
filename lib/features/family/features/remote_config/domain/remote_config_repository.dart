import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/*
  Repository that lets you subscribe to a remote config key
  and be notified of changes of the value coupled to it.
 */
class RemoteConfigRepository {
  RemoteConfigRepository() {
    _init();
  }

  // A BehaviorSubject emits the last value when a listener subscribes
  // A regular dart stream doesn't
  final Map<String, BehaviorSubject<RemoteConfigValue>> _subscriptions = {};

  Stream<RemoteConfigValue>? subscribeToRemoteConfigValue(String key) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    if (!_subscriptions.containsKey(key)) {
      _subscriptions[key] = BehaviorSubject<RemoteConfigValue>();
    }
    final value = remoteConfig.getValue(key);
    _subscriptions[key]?.add(value);
    return _subscriptions[key]!.stream;
  }

  Future<void> _init() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: kDebugMode
              ? const Duration(minutes: 5)
              : const Duration(hours: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      _getRemoteConfigValuesAndUpdateListeners(remoteConfig);
      _listenForRemoteConfigChanges(remoteConfig);
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  void _listenForRemoteConfigChanges(FirebaseRemoteConfig remoteConfig) {
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      _getRemoteConfigValuesAndUpdateListeners(remoteConfig);
    });
  }

  void _getRemoteConfigValuesAndUpdateListeners(
      FirebaseRemoteConfig remoteConfig) {
    for (final key in _subscriptions.keys) {
      final value = remoteConfig.getValue(key);
      _subscriptions[key]?.add(value);
    }
  }
}
