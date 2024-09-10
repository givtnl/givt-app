import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class ParentOverviewWidget extends StatelessWidget {
  const ParentOverviewWidget({
    required this.profiles,
    this.cachedMembers = const [],
    super.key,
  });

  final List<Profile> profiles;
  final List<Member> cachedMembers;

  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...profiles.map(
            (profile) {
              final isMainUser = profile.id == profiles[0].id;
              return GestureDetector(
                onTap: () async {
                  if (!context.mounted) return;
                  if (!isMainUser) return;

                  unawaited(
                    context.read<ProfilesCubit>().setActiveProfile(
                          profile.id,
                        ),
                  );
                  unawaited(
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.parentProfileIconClicked,
                    ),
                  );

                  await FamilyAuthUtils.authenticateUser(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (context, {isUSUser}) async {
                        await context.pushNamed(
                          FamilyPages.parentHome.name,
                          extra: profile,
                        );
                        await AnalyticsHelper.setUserProperties(
                          userId: profile.id,
                        );
                      },
                    ),
                  );
                },
                child: layout(
                  pictureUrl: profile.pictureURL,
                  firstName: profile.firstName,
                  isMainUser: isMainUser,
                ),
              );
            },
          ),
          ...cachedMembers
              .where((element) => element.type == ProfileType.Parent)
              .map(
                (member) => layout(
                  assetPicture: 'assets/images/default_hero.svg',
                  firstName: member.firstName ?? '',
                  isMainUser: false,
                ),
              ),
        ],
      ),
    );
  }

  Widget layout({
    required String firstName,
    required bool isMainUser,
    String? pictureUrl,
    String? assetPicture,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pictureUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.network(
                  pictureUrl,
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          if (assetPicture != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.asset(
                  assetPicture,
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              LabelMediumText(
                firstName,
                color: FamilyAppTheme.defaultTextColor,
              ),
              const SizedBox(width: 4),
              if (isMainUser)
                const FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: FamilyAppTheme.defaultTextColor,
                  size: 16,
                ),
            ],
          ),
        ],
      );
}
