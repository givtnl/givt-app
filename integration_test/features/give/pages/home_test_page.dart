import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

import '../../../widget_tester_extension.dart';

class HomeTestPage {
  HomeTestPage({required this.nativeTester});

  final WidgetTester nativeTester;

  // Locators
  final Finder appBar = find.byKey(const ValueKey('EU-Home-AppBar'));
  final Finder menuButton = find.byIcon(Icons.menu);
  final Finder faqButton = find.byIcon(Icons.question_mark_outlined);
  final Finder debugButton = find.byIcon(Icons.admin_panel_settings);
  final Finder drawer = find.byType(CustomNavigationDrawer);
  final Finder pageView = find.byType(PageView);
  final Finder chooseAmount = find.byType(ChooseAmount);
  final Finder chooseCategory = find.byType(ChooseCategory);
  final Finder animatedSwitch = find.byType(AnimatedSwitch);

  // Actions
  Future<void> tapMenuButton() async {
    await nativeTester.tap(menuButton);
    await nativeTester.pumpAndSettle();
  }

  Future<void> tapFaqButton() async {
    await nativeTester.tap(faqButton);
    await nativeTester.pumpAndSettle();
  }

  Future<void> tapDebugButton() async {
    await nativeTester.tap(debugButton);
    await nativeTester.pumpAndSettle();
  }

  Future<void> swipeToChooseCategory() async {
    await nativeTester.drag(pageView, const Offset(-300, 0));
    await nativeTester.pumpAndSettle();
  }

  Future<void> swipeToChooseAmount() async {
    await nativeTester.drag(pageView, const Offset(300, 0));
    await nativeTester.pumpAndSettle();
  }

  // Assertions
  Future<void> verifyAppBarIsVisible() async {
    await nativeTester.pumpUntilVisible(appBar);
    expect(appBar, findsOneWidget);
  }

  Future<void> verifyMenuButtonIsVisible() async {
    expect(menuButton, findsOneWidget);
  }

  Future<void> verifyFaqButtonIsVisible() async {
    expect(faqButton, findsOneWidget);
  }

  Future<void> verifyDebugButtonIsVisible() async {
    expect(debugButton, findsOneWidget);
  }

  Future<void> verifyDrawerIsVisible() async {
    expect(drawer, findsOneWidget);
  }

  Future<void> verifyPageViewIsVisible() async {
    expect(pageView, findsOneWidget);
  }

  Future<void> verifyChooseAmountIsVisible() async {
    expect(chooseAmount, findsOneWidget);
  }

  Future<void> verifyChooseCategoryIsVisible() async {
    expect(chooseCategory, findsOneWidget);
  }

  Future<void> verifyAnimatedSwitchIsVisible() async {
    expect(animatedSwitch, findsOneWidget);
  }
}
