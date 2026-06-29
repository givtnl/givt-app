import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:go_router/go_router.dart';

/// Imperative navigation helpers for the external donation create flow.
///
/// Create steps are pushed on top of a GoRouter screen (My giving, overview, …).
/// Routes are tagged so the flow can be closed without [Route.isFirst], which
/// would desync GoRouter and leave menu navigation broken.
abstract final class ExternalDonationCreateNavigation {
  static const flowRouteName = 'EXTERNAL_DONATION_CREATE_FLOW';

  static Route<T> flowRoute<T>(BuildContext context, Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute<T>(
        settings: const RouteSettings(name: flowRouteName),
        builder: (context) => page,
      );
    }
    return MaterialPageRoute<T>(
      settings: const RouteSettings(name: flowRouteName),
      builder: (context) => page,
    );
  }

  static Future<T?> pushFlow<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(flowRoute<T>(context, page));
  }

  /// Pops all tagged create-flow routes, returning to the GoRouter screen below.
  static void exitFlow(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name != flowRouteName,
    );
  }

  /// Finishes the create flow after a successful submission.
  static void completeFlowToOverview(BuildContext context) {
    final originRoute = GoRouter.of(context).state.name;

    if (originRoute == Pages.externalDonations.name) {
      exitFlow(context);
      return;
    }

    // Rebuild the GoRouter stack so imperative create routes are cleared and
    // menu navigation stays in sync (e.g. when started from My giving).
    context.goNamed(Pages.externalDonations.name);
  }
}

extension ExternalDonationCreateRoute on Widget {
  Route<T> toCreateFlowRoute<T>(BuildContext context) {
    return ExternalDonationCreateNavigation.flowRoute<T>(context, this);
  }
}
