import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_panel.dart'
    show
        ExternalDonationCreatePreviewHistoryItemStyle,
        ExternalDonationCreatePreviewPanel;
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

/// Builds the pinned preview panel for a create-flow step.
ExternalDonationCreatePreviewPanel? externalDonationCreatePreviewForStep(
  BuildContext context,
  ExternalDonationCreateUIModel uiModel,
  ExternalDonationCreateFlowStep step, {
  bool showSectionTitle = true,
  ExternalDonationCreatePreviewHistoryItemStyle historyItemStyle =
      ExternalDonationCreatePreviewHistoryItemStyle.createFlow,
}) {
  final auth = context.read<AuthCubit>().state;
  final country = Country.fromCode(auth.user.country);
  final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
  final rows = uiModel.previewRowsForStep(
    step,
    currencySymbol: currency,
    formatAmount: (amount) => Util.formatNumberComma(amount, country),
    locals: context.l10n,
  );
  if (rows.isEmpty) {
    return null;
  }
  return ExternalDonationCreatePreviewPanel(
    rows: rows,
    moreRecordsLabel: uiModel.previewMoreRecordsLabel(context.l10n),
    showSectionTitle: showSectionTitle,
    historyItemStyle: historyItemStyle,
  );
}
