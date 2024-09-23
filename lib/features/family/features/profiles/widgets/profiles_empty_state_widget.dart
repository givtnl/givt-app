import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class ProfilesEmptyStateWidget extends StatelessWidget {
  const ProfilesEmptyStateWidget({
    required this.onRetry,
    super.key,
  });

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RetryErrorWidget(
      onTapPrimaryButton: onRetry,
      errorText: 'There are no profiles attached to the current user.',
      secondaryButtonText: 'Logout',
      onTapSecondaryButton: () => logout(context, fromLogoutBtn: true),
      secondaryButtonAnalyticsEvent: AnalyticsEvent(
        AmplitudeEvents.logoutClicked,
      ),
    );
  }
}
