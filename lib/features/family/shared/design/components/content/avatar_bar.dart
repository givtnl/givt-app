import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_widget.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';

class AvatarBar extends StatelessWidget {
  const AvatarBar({
    required this.uiModel,
    required this.onAvatarTapped,
    this.backgroundColor = Colors.transparent,
    this.circleSize = 64,
    this.textColor,
    super.key,
  });

  final AvatarBarUIModel uiModel;
  final void Function(int index) onAvatarTapped;
  final Color backgroundColor;
  final double circleSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: SizedBox(
        height: 92,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: uiModel.avatarUIModels.length,
          itemBuilder: (context, index) {
            final avatarUIModel = uiModel.avatarUIModels[index];
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 24 : 0),
                child: AvatarWidget(
                  uiModel: avatarUIModel,
                  onTap: () => onAvatarTapped(index),
                  circleSize: circleSize,
                  textColor: textColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
