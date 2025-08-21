import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class SummaryConversationItem extends StatelessWidget {
  const SummaryConversationItem({required this.uiModel, super.key});

  final ConversationUIModel uiModel;
  static const int size = 80;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: FamilyAppTheme.highlight40,
        ),
        color: FamilyAppTheme.highlight98,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: FamilyAppTheme.info95,
            ),
            child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: FunAvatar.fromProfile(
                  uiModel.profile,
                  size: 80,
                )),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  uiModel.profile.firstName,
                  color: FamilyAppTheme.highlight40,
                ),
                const SizedBox(height: 4),
                BodySmallText(
                  uiModel.sentence,
                  color: FamilyAppTheme.highlight50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
