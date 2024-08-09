import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ParentOverviewWidget extends StatelessWidget {
  const ParentOverviewWidget({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: profiles.map(
          (profile) {
            final isMainUser = profile.id == profiles[0].id;
            return GestureDetector(
              onTap: () async {
                if (!context.mounted) return;
                if (!isMainUser) return;

                await FamilyAuthUtils.authenticateUser(
                  context,
                  checkAuthRequest: CheckAuthRequest(
                    navigate: (context, {isUSUser}) async {
                      await context.pushNamed(
                        FamilyPages.parentHome.name,
                        extra: profile.id,
                      );
                      await AnalyticsHelper.setUserProperties(
                        userId: profile.id,
                      );
                    },
                  ),
                );

                unawaited(AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.parentProfileIconClicked,
                ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SvgPicture.network(
                        profile.pictureURL,
                        width: 64,
                        height: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        profile.firstName,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isMainUser
                                ? AppTheme.defaultTextColor
                                : AppTheme.tertiary20),
                      ),
                      const SizedBox(width: 4),
                      if (profile.id == profiles[0].id)
                        FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: AppTheme.defaultTextColor,
                          size:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
