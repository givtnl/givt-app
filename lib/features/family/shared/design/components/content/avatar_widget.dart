import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/unlocked_badge/presentation/widgets/unlocked_badge_widget.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    required this.uiModel,
    required this.onTap,
    this.featureId,
    this.circleSize = 64,
    this.textColor,
    super.key,
  });

  final AvatarUIModel uiModel;
  final void Function() onTap;
  final double circleSize;
  final Color? textColor;
  final String? featureId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uiModel.hasDonated ? null : onTap,
      child: UnlockedBadgeWidget(
        featureId: featureId,
        profileId: uiModel.guid!,
        child: SizedBox(
          width: circleSize,
          height: circleSize + 44,
          child: Column(
            children: [
              SizedBox(
                width: circleSize,
                height: circleSize + 8,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Semantics(
                        identifier: uiModel.avatar,
                        label: uiModel.avatar,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FamilyAppTheme.primary80,
                              width: uiModel.isSelected ? 6 : 0,
                            ),
                          ),
                          child: uiModel.avatar != null
                              ? FunAvatar.hero(uiModel.avatar!, size: circleSize)
                              : uiModel.customAvatarUIModel != null
                                  ? FunAvatar.custom(
                                      uiModel.customAvatarUIModel!,
                                      size: circleSize,
                                    )
                                  : FunAvatar.defaultHero(size: circleSize),
                        ),
                      ),
                    ),
                    if (uiModel.hasDonated)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 19,
                          height: 19,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: FamilyAppTheme.primary80,
                          ),
                          child: const FaIcon(
                            size: 12,
                            FontAwesomeIcons.check,
                            color: FamilyAppTheme.primary20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: LabelSmallText(
                  uiModel.text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
