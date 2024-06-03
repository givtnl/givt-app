import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/utils/utils.dart';
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
    final user = context.read<AuthCubit>().state.user;
    final imgSize = (MediaQuery.of(context).size.width - 24 * 2 - 20 * 2) / 3;

    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: _padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: profiles
                .map(
                  (profile) => Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            Pages.childrenOverview.name,
                          );
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.profilePressed,
                            eventProperties: {
                              'profile_name':
                                  '${profile.firstName} ${profile.lastName}',
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SvgPicture.network(
                              profile.pictureURL,
                              width: profile.id == user.guid ? imgSize : 48,
                              height: profile.id == user.guid ? imgSize : 48,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(profile.firstName,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
