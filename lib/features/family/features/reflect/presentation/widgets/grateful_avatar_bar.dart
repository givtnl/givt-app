import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GratefulAvatarBar extends StatelessWidget {
  const GratefulAvatarBar({
    required this.uiModel,
    required this.onAvatarTapped,
    super.key,
  });

  final GratefulAvatarBarUIModel uiModel;
  final void Function(int index) onAvatarTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FamilyAppTheme.primary99,
      padding: const EdgeInsets.only(left: 24, top: 8, bottom: 16),
      child: SizedBox(
        height: 92,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: uiModel.avatarUIModels.length,
          itemBuilder: (context, index) {
            final avatarUIModel = uiModel.avatarUIModels[index];
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GratefulAvatar(
                uiModel: avatarUIModel,
                onTap: () => onAvatarTapped(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
