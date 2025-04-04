import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/edit_avatar_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';

class LoggedInParentAvatar extends StatelessWidget {
  const LoggedInParentAvatar({
    required this.user,
    super.key,
  });

  final UserExt user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      bloc: context.read<ProfilesCubit>(),
      builder: (context, state) {
        if (state is ProfilesLoadingState) {
          return const CircularProgressIndicator();
        }
        return Column(
          children: [
            Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.editAvatarPictureClicked,
                      );

                      Navigator.of(context).push(
                        EditAvatarScreen(userGuid: user.guid).toRoute(context),
                      );
                    },
                    customBorder: const CircleBorder(),
                    splashColor: Theme.of(context).primaryColor,
                    child: FunAvatar.fromProfile(
                      state.profiles
                          .where((profile) => profile.id == user.guid)
                          .first,
                      size: 100,
                    ),
                  ),
                ),
                Positioned(
                  top: -15,
                  right: -15,
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.pen,
                      size: 20,
                    ),
                    onPressed: () {
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.editAvatarIconClicked,
                      );

                      Navigator.of(context).push(
                        EditAvatarScreen(userGuid: user.guid).toRoute(context),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        );
      },
    );
  }
}
