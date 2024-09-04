import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ParentAvatarSelectionScreen extends StatelessWidget {
  const ParentAvatarSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (BuildContext context, EditProfileState state) {
        if (state.status == EditProfileStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        } else if (state.status == EditProfileStatus.edited) {
          context.read<ProfilesCubit>().fetchAllProfiles();
          context.read<AuthCubit>().refreshUser();
          context.pop();
        }
      },
      builder: (BuildContext context, EditProfileState editProfileState) =>
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
              automaticallyImplyLeading:
                  editProfileState.status != EditProfileStatus.editing,
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
  required EditProfileState editProfileState,
}) {
  if (avatarsState.status == AvatarsStatus.loading ||
      editProfileState.status == EditProfileStatus.editing) {
    return const Center(child: CircularProgressIndicator());
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
                        .read<EditProfileCubit>()
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
                  text: context.l10n.save,
                  onTap: editProfileState.isSameProfilePicture
                      ? null
                      : () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.avatarSaved,
                            eventProperties: {
                              'filename':
                                  editProfileState.selectedProfilePicture,
                            },
                          );
                          context.read<EditProfileCubit>().editProfile();
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
