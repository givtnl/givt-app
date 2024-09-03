import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';

class NoticeDialog extends StatelessWidget {
  const NoticeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: 'Direct Notice',
      content: BodySmallText(context.l10n.directNoticeText),
    );
  }
}
