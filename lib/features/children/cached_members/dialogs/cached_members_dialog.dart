import 'package:flutter/material.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_content.dart';
import 'package:givt_app/shared/widgets/dialogs/card_dialog.dart';
import 'package:givt_app/utils/app_theme.dart';

class CachedMembersDialog extends StatelessWidget {
  const CachedMembersDialog({super.key,});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AppTheme.lightTheme,
        child: const CardDialog(child: CachedMembersDialogContent()));
  }
}
