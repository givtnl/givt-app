import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class SummaryConversationItem extends StatelessWidget {
  const SummaryConversationItem({required this.uiModel, super.key});

  final ConversationUIModel uiModel;
  static const int size = 80;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: SvgPicture.network(
                          uiModel.profilePicture,
                          width: 80,
                          height: 80,
                        ),
                      ),
            ),
            LabelSmallText(uiModel.profileName),
          ],
        ),
        LabelMediumText(uiModel.sentence),
      ],
    );
  }
}
