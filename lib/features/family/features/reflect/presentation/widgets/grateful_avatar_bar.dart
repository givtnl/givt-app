import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar.dart';

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
      margin: const EdgeInsets.only(left: 24, top: 8, bottom: 16),
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
    );
  }
}
