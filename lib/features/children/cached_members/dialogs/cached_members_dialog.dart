import 'package:flutter/material.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_content.dart';
import 'package:givt_app/shared/widgets/dialogs/card_dialog.dart';

class CachedMembersDialog extends StatelessWidget {
  const CachedMembersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardDialog(child: CachedMembersDialogContent());
  }
}
