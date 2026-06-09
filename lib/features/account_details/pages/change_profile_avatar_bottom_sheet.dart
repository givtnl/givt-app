import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/widgets/account_settings_avatar.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/features/edit_parent_profile/models/edit_parent_profile.dart';
import 'package:givt_app/features/family/features/edit_parent_profile/repositories/edit_parent_profile_repository.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class ChangeProfileAvatarBottomSheet extends StatefulWidget {
  const ChangeProfileAvatarBottomSheet({
    required this.currentProfilePicture,
    super.key,
  });

  final String currentProfilePicture;

  @override
  State<ChangeProfileAvatarBottomSheet> createState() =>
      _ChangeProfileAvatarBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    required String currentProfilePicture,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => ChangeProfileAvatarBottomSheet(
        currentProfilePicture: currentProfilePicture,
      ),
    );
  }
}

class _ChangeProfileAvatarBottomSheetState
    extends State<ChangeProfileAvatarBottomSheet> {
  late String _selectedProfilePicture;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedProfilePicture = AccountSettingsAvatar.fileNameFromProfilePicture(
      widget.currentProfilePicture,
    );
    getIt<AvatarsCubit>().fetchAvatars();
  }

  Future<void> _save() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await getIt<EditParentProfileRepository>().editProfile(
        editProfile: EditParentProfile(profilePicture: _selectedProfilePicture),
      );

      if (!mounted) {
        return;
      }

      await context.read<AuthCubit>().refreshUser();

      if (!mounted) {
        return;
      }

      context.pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<AvatarsCubit>();

    return FunBottomSheet(
      title: context.l10n.registrationAvatarSelectionTitle,
      content: Column(
        children: [
          const SizedBox(height: 24),
          SingleChildScrollView(
            child: BlocBuilder<AvatarsCubit, AvatarsState>(
              bloc: cubit,
              builder: (context, state) {
                if (state.status != AvatarsStatus.loaded) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: state.avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = state.avatars[index];

                    return AvatarItem(
                      filename: avatar.fileName,
                      isSelected: avatar.fileName == _selectedProfilePicture,
                      onSelectProfilePicture: (profilePicture) {
                        setState(
                          () => _selectedProfilePicture = profilePicture,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          FunButton(
            text: context.l10n.save,
            isLoading: _isSaving,
            onTap: _save,
            analyticsEvent: AnalyticsEventName.avatarSaved.toEvent(
              parameters: {
                'filename': _selectedProfilePicture,
              },
            ),
          ),
        ],
      ),
      closeAction: () => context.pop(),
    );
  }
}
