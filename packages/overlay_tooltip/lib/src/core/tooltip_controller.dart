import 'dart:async';

import 'package:flutter/material.dart';

import '../model/tooltip_widget_model.dart';

abstract class TooltipControllerImpl {
  List<OverlayTooltipModel> _playableWidgets = [];
  StreamController<OverlayTooltipModel?> _widgetsPlayController =
      StreamController.broadcast();

  bool _playActive = false;

  Stream<OverlayTooltipModel?> get widgetsPlayStream =>
      _widgetsPlayController.stream
        ..listen((event) {
          if (event != null) {
            _playActive = true;
          } else {
            _playActive = false;
          }
        });

  VoidCallback? _onDoneCallback;
  Future<bool> Function(int instantiatedWidgetLength)? _startWhenCallback;

  int _nextPlayIndex = 0;

  int get nextPlayIndex => _nextPlayIndex;

  int get playWidgetLength => _playableWidgets.length;

  void start([int? displayIndex]) {
    _nextPlayIndex = 0;
    _playableWidgets.sort((a, b) => a.displayIndex.compareTo(b.displayIndex));

    if (displayIndex != null) {
      _nextPlayIndex =
          _playableWidgets.indexWhere((e) => e.displayIndex == displayIndex);
      if (_nextPlayIndex.isNegative) _nextPlayIndex = 0;
    }

    if (playWidgetLength == 0) {
      throw 'No overlay tooltip item has been '
          'initialized, consider inserting controller.start() in a button '
          'callback or using the startWhen method';
    }

    _widgetsPlayController.sink.add(_playableWidgets[_nextPlayIndex]);
  }

  void setStartWhen(
      Future<bool> Function(int initializedWidgetLength) callback) async {
    _startWhenCallback = callback;
  }

  next() {
    _nextPlayIndex++;
    if (_nextPlayIndex < _playableWidgets.length) {
      _widgetsPlayController.sink.add(_playableWidgets[_nextPlayIndex]);
    } else {
      _widgetsPlayController.sink.add(null);
      _onDoneCallback?.call();
    }
  }

  previous() {
    if (_nextPlayIndex > 0) {
      _nextPlayIndex--;
      _widgetsPlayController.sink.add(_playableWidgets[_nextPlayIndex]);
    }
  }

  pause() {
    _widgetsPlayController.sink.add(null);
  }

  dismiss() {
    _widgetsPlayController.sink.add(null);
    _onDoneCallback?.call();
  }

  void addPlayableWidget(OverlayTooltipModel model) async {
    if (_playableWidgets
        .map((e) => e.displayIndex)
        .toList()
        .contains(model.displayIndex)) {
      int prevIndex = _playableWidgets.indexOf(model);
      _playableWidgets[prevIndex] = model;
    } else {
      _playableWidgets.add(model);
    }

    if ((await _startWhenCallback?.call(_playableWidgets.length)) ?? false) {
      if (!_playActive) {
        start();
      }
    }
  }

  void onDone(Function() onDone) {
    _onDoneCallback = onDone;
  }

  void dispose() {
    _widgetsPlayController.close();
  }
}
