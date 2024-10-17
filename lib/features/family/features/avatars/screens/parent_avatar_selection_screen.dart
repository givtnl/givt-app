import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ParentAvatarSelectionScreen extends StatefulWidget {
  const ParentAvatarSelectionScreen({
    super.key,
  });

  @override
  State<ParentAvatarSelectionScreen> createState() =>
      _ParentAvatarSelectionScreenState();
}

class _ParentAvatarSelectionScreenState
    extends State<ParentAvatarSelectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getIt<AvatarsCubit>().fetchAvatars();
  }

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
            appBar: const FunTopAppBar(
              title: 'Choose your avatar',
              leading: GivtBackButtonFlat(),
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
  required EditProfileState editProfileState,
}) {
  if (avatarsState.status == AvatarsStatus.loading ||
      editProfileState.status == EditProfileStatus.editing) {
    return const Center(child: CircularProgressIndicator());
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              FunButton(
                text: context.l10n.save,
                onTap: editProfileState.isSameProfilePicture
                    ? null
                    : () {
                        context.read<EditProfileCubit>().editProfile();
                      },
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.avatarSaved,
                  parameters: {
                    'filename': editProfileState.selectedProfilePicture,
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
