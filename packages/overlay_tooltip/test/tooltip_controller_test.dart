import 'package:flutter_test/flutter_test.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:flutter/material.dart';

void main() {
  test('Adds widget tooltip to playable widget list', () {
    final controller = TooltipController();

    controller.addPlayableWidget(overlayTooltipModel(1));

    expect(controller.playWidgetLength, 1);
  });

  test(
      'Throws error when tooltip play is started with empty widget tooltip list',
      () {
    final controller = TooltipController();
    expect(controller.start, throwsA(isA<String>()));
  });

  test('Starts play when playable widget list is not empty', () async {
    final controller = TooltipController();

    final model1 = overlayTooltipModel(1);
    final model2 = overlayTooltipModel(2);
    controller.addPlayableWidget(model1);
    controller.addPlayableWidget(model2);

    expect(controller.playWidgetLength, 2);

    controller.widgetsPlayStream.listen(expectAsync1((value) {}, count: 2));

    controller.start();
    expect(controller.nextPlayIndex, 0);

    controller.next();
    expect(controller.nextPlayIndex, 1);
  });

  test('starts play automatically when startWhen condition is met', () {
    final controller = TooltipController();
    final model1 = overlayTooltipModel(1);
    final model2 = overlayTooltipModel(2);

    controller.setStartWhen(
        (initializedWidgetLength) async => initializedWidgetLength == 2);

    // playstream encounters objects, hence play started
    // because condition is met
    controller.widgetsPlayStream.listen(expectAsync1((value) {
      expect(value, equals(model1));
    }, count: 1));

    controller.addPlayableWidget(model1);
    controller.addPlayableWidget(model2);
  });

  test('Does not play when startWhen condition is not met', () {
    final controller = TooltipController();
    final model1 = overlayTooltipModel(1);

    controller.setStartWhen(
        (initializedWidgetLength) async => initializedWidgetLength == 2);

    // playstream does not encounter any objects, hence play not started
    // because condition not met
    controller.widgetsPlayStream.listen(expectAsync1((value) {}, count: 0));

    controller.addPlayableWidget(model1);
  });

  test('Starts play at selected index', () {
    final controller = TooltipController();
    final model1 = overlayTooltipModel(1);
    final model2 = overlayTooltipModel(2);

    // playstream encounters objects, hence play started
    // because condition is met
    controller.widgetsPlayStream.listen(expectAsync1((value) {
      expect(value, equals(model2));
    }, count: 1));

    controller.addPlayableWidget(model1);
    controller.addPlayableWidget(model2);

    controller.start(2);
  });
}

OverlayTooltipModel overlayTooltipModel(int displayIndex) =>
    OverlayTooltipModel(
        absorbPointer: true,
        child: Container(),
        tooltip: (cont) => Container(),
        widgetKey: GlobalKey(),
        vertPosition: TooltipVerticalPosition.TOP,
        horPosition: TooltipHorizontalPosition.LEFT,
        displayIndex: displayIndex);
