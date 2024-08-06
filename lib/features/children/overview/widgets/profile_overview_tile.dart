import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/legacy_profile.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ProfileOverviewTile extends StatelessWidget {
  const ProfileOverviewTile({
    required this.profile,
    super.key,
  });

  final LegacyProfile profile;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currencySymbol = Util.getCurrencySymbol(countryCode: user.country);
    final isGivtAccount = profile.firstName == user.firstName;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: _getBorderColor(context, isGivtAccount),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            width: 2,
            color: _getBorderColor(
              context,
              isGivtAccount,
            ),
          ),
          backgroundColor: _getBackgroundColor(context),
        ),
        onPressed: () => _onTap(context, isGivtAccount),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SvgPicture.network(
                profile.pictureURL,
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.firstName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.givtBlue,
                  ),
            ),
            if (profile.isChild)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  profile.wallet.pendingAllowance
                      ? context.l10n.vpcNoFundsWaiting
                      : '$currencySymbol${profile.wallet.balance.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.givtBlue,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, bool isGivtAccount) {
    if (profile.isAdult) {
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.adultProfileTileClicked,
        eventProperties: {
          'name': profile.firstName,
        },
      );
      if (isGivtAccount) {
        context.pushNamed(
          FamilyPages.familyPersonalInfoEdit.name,
          extra: true,
        );
      }
      return;
    }
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.childProfileClicked,
      eventProperties: {
        'name': profile.firstName,
      },
    );

    context.pushNamed(
      FamilyPages.childDetails.name,
      extra: [
        context.read<FamilyOverviewCubit>(),
        profile,
      ],
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (profile.isAdult) {
      return AppTheme.givtLightBackgroundBlue;
    }
    if (profile.isChild) {
      return AppTheme.givtLightBackgroundGreen;
    }
    return Theme.of(context).colorScheme.error;
  }

  Color _getBorderColor(BuildContext context, bool isGivtAccount) {
    if (profile.isAdult) {
      if (isGivtAccount) {
        return AppTheme.givtBorderBlue;
      }
      return AppTheme.givtDisabledBorderBlue;
    }
    if (profile.isChild) {
      return AppTheme.givtLightGreen;
    }
    return Theme.of(context).colorScheme.onError;
  }
}
