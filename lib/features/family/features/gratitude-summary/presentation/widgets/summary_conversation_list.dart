import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/summary_conversation_item.dart';

class SummaryConversationList extends StatelessWidget {
  const SummaryConversationList({required this.conversations, super.key});

  final List<ConversationUIModel> conversations;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SummaryConversationItem(uiModel: conversations[index]);
      },
      itemCount: conversations.length,
    );
  }
}
