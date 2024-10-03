import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar.dart';

class GratefulAvatarBar extends StatelessWidget {
  const GratefulAvatarBar({
    required this.uiModel,
    required this.onAvatarTapped,
    this.backgroundColor = Colors.transparent,
    this.withLeftPadding = true,
    this.circleSize = 64,
    super.key,
  });

  final GratefulAvatarBarUIModel uiModel;
  final void Function(int index) onAvatarTapped;
  final Color backgroundColor;
  final bool withLeftPadding;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding:
          EdgeInsets.only(left: withLeftPadding ? 24 : 0, top: 8, bottom: 16),
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
                circleSize: circleSize,
              ),
            );
          },
        ),
      ),
    );
  }
}
