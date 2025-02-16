import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/features/edit_child_profile/cubit/edit_child_profile_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/reward_banner_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';

class KidsAvatarSelectionScreen extends StatefulWidget {
  const KidsAvatarSelectionScreen({
    super.key,
  });

  @override
  State<KidsAvatarSelectionScreen> createState() =>
      _KidsAvatarSelectionScreenState();
}

class _KidsAvatarSelectionScreenState extends State<KidsAvatarSelectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getIt<AvatarsCubit>().fetchAvatars();
  }

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
                  Theme.of(context).colorScheme.primary.withOpacity(.5),
              builder: (context) => const MissionCompletedBannerDialog(
                missionName: 'Avatar updated',
              ),
            );
          }
        }
      },
      builder: (BuildContext context, EditChildProfileState editProfileState) =>
          BlocConsumer<AvatarsCubit, AvatarsState>(
        bloc: getIt<AvatarsCubit>(),
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
          return FunScaffold(
            appBar: FunTopAppBar(
              title: 'Choose your avatar',
              leading: editProfileState.status != EditChildProfileStatus.editing
                  ? const GivtBackButtonFlat()
                  : null,
            ),
            body: _getContent(
              context: context,
              avatarsState: avatarsState,
              editProfileState: editProfileState,
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
        SliverGrid(
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              FunButton(
                text: 'Save',
                isDisabled: editProfileState.isSameProfilePicture,
                onTap: () {
                  context.read<EditChildProfileCubit>().editProfile();
                },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.saveAvatarClicked,
                  parameters: {
                    AnalyticsHelper.avatarImageKey:
                        editProfileState.selectedProfilePicture,
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
