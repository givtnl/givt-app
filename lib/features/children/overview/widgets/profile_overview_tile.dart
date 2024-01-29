import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ProfileOverviewTile extends StatelessWidget {
  const ProfileOverviewTile({
    required this.profile,
    super.key,
  });

  final Profile profile;
  @override
  Widget build(BuildContext context) {
    final isGivtAccount =
        profile.firstName == context.read<AuthCubit>().state.user.firstName;
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
              )),
          backgroundColor: _getBackgroundColor(context),
        ),
        onPressed: () => _onTap(context, isGivtAccount),
        child: SizedBox(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      color: AppTheme.givtBlue,
                    ),
              ),
            ],
          ),
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
          Pages.personalInfoEdit.name,
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
      Pages.childDetails.name,
      extra: [
        context.read<FamilyOverviewCubit>(),
        profile,
      ],
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (profile.isAdult) {
      return Color(0xFFF3F8FD);
    }
    if (profile.isChild) {
      return AppTheme.givtLightBackgroundGreen;
    }
    return Theme.of(context).colorScheme.error;
  }

  Color _getBorderColor(BuildContext context, bool isGivtAccount) {
    if (isGivtAccount) {
      return Color(0xFFA4CBF3);
    }
    if (profile.isAdult) {
      return Color(0xFFDEECFA);
    }
    if (profile.isChild) {
      return AppTheme.givtLightGreen;
    }
    return Theme.of(context).colorScheme.onError;
  }
}
