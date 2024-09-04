import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/reward_banner_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';

class KidsAvatarSelectionScreen extends StatelessWidget {
  const KidsAvatarSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditChildProfileCubit, EditChildProfileState>(
      listener: (BuildContext context, EditChildProfileState state) {
        if (state.status == EditChildProfileStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        } else if (state.status == EditChildProfileStatus.edited) {
          context.pop();
          if (state.isRewardAchieved) {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.rewardAchieved,
              eventProperties: {
                AnalyticsHelper.rewardKey: 'Avatar updated',
              },
            );
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              barrierColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.25),
              builder: (context) => const RewardBannerDialog(),
            );
          }
        }
      },
      builder: (BuildContext context, EditChildProfileState editProfileState) =>
          BlocConsumer<AvatarsCubit, AvatarsState>(
        listener: (BuildContext context, AvatarsState state) {
          if (state.status == AvatarsStatus.error) {
            SnackBarHelper.showMessage(
              context,
              text: state.error,
              isError: true,
            );
          }
        },
        builder: (context, avatarsState) {
          return Scaffold(
            appBar: AppBar(
              title: const TitleLargeText(
                'Choose your avatar',
              ),
              automaticallyImplyLeading: false,
              leading: editProfileState.status != EditChildProfileStatus.editing
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      onPressed: () {
                        SystemSound.play(SystemSoundType.click);
                        context.pop();
                      },
                    )
                  : null,
            ),
            body: SafeArea(
              child: _getContent(
                context: context,
                avatarsState: avatarsState,
                editProfileState: editProfileState,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _getContent({
  required BuildContext context,
  required AvatarsState avatarsState,
  required EditChildProfileState editProfileState,
}) {
  if (avatarsState.status == AvatarsStatus.loading ||
      editProfileState.status == EditChildProfileStatus.editing) {
    return const CustomCircularProgressIndicator();
  }

  if (avatarsState.status == AvatarsStatus.loaded) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AvatarItem(
                  onSelectProfilePicture: (profilePicture) {
                    context
                        .read<EditChildProfileCubit>()
                        .selectProfilePicture(profilePicture);
                  },
                  filename: avatarsState.avatars[index].fileName,
                  url: avatarsState.avatars[index].pictureURL,
                  isSelected: avatarsState.avatars[index].fileName ==
                      editProfileState.selectedProfilePicture,
                );
              },
              childCount: avatarsState.avatars.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                child: FunButton(
                  text: 'Save',
                  isDisabled: editProfileState.isSameProfilePicture,
                  onTap: () {
                    context.read<EditChildProfileCubit>().editProfile();
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.saveAvatarClicked,
                      eventProperties: {
                        AnalyticsHelper.avatarImageKey:
                            editProfileState.selectedProfilePicture,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  return Container();
}
