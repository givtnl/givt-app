import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';

class EditAllowanceSuccessPage extends StatelessWidget {
  const EditAllowanceSuccessPage({required this.uiModel, super.key});

  final EditAllowanceSuccessUIModel uiModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomGreenElevatedButton(
          title: context.l10n.ready,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}