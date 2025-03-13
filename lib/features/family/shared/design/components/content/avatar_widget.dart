import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
      {required this.uiModel,
      required this.onTap,
      this.circleSize = 64,
      this.textColor,
      super.key});

  final AvatarUIModel uiModel;
  final void Function() onTap;
  final double circleSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uiModel.hasDonated ? null : onTap,
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
                      identifier: uiModel.avatarUrl.split('/').last,
                      label: uiModel.avatarUrl.split('/').last,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: FamilyAppTheme.primary80,
                            width: uiModel.isSelected ? 6 : 0,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Semantics(
                            identifier: uiModel.avatarUrl.split('/').last,
                            child: SvgPicture.network(
                              uiModel.avatarUrl,
                              width: circleSize,
                              height: circleSize,
                            ),
                          ),
                        ),
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
    );
  }
}
