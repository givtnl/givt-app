import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/amount_presets/pages/change_amount_presets_bottom_sheet.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/shared/pages/change_max_amount_bottom_sheet.dart';
import 'package:givt_app/shared/pages/fingerprint_bottom_sheet.dart';
import 'package:givt_app/utils/auth_utils.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

/// Shared navigation helpers for account settings and the navigation drawer.
abstract final class AccountSettingsActions {
  static Future<void> openMaxAmount(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final country = Country.fromCode(user.country);

    return AuthUtils.checkToken(
      context,
      checkAuthRequest: CheckAuthRequest(
        navigate: (context) => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => ChangeMaxAmountBottomSheet(
            maxAmount: user.amountLimit,
            icon: Util.getCurrencyIconData(country: country),
          ),
        ),
      ),
    );
  }

  static Future<void> openAmountPresets(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ChangeAmountPresetsBottomSheet(),
    );
  }

  static Future<void> openPlatformContribution(BuildContext context) {
    return AuthUtils.checkToken(
      context,
      checkAuthRequest: CheckAuthRequest(
        navigate: (context) async {
          context.pushNamed(Pages.platformContribution.name);
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: AnalyticsEventName.platformContributionNavigationClicked,
            ),
          );
        },
      ),
    );
  }

  static Future<void> openBiometricSetup(
    BuildContext context, {
    required bool isFingerprint,
  }) {
    return AuthUtils.checkToken(
      context,
      checkAuthRequest: CheckAuthRequest(
        navigate: (context) => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => FingerprintBottomSheet(
            isFingerprint: isFingerprint,
          ),
        ),
      ),
    );
  }

  static Future<void> openUnregister(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    if (user.tempUser) {
      context.pushNamed(Pages.unregister.name);
      return Future.value();
    }

    return AuthUtils.checkToken(
      context,
      checkAuthRequest: CheckAuthRequest(
        navigate: (context) async => context.pushNamed(Pages.unregister.name),
      ),
    );
  }
}
