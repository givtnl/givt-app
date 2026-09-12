import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/constants/donation_amount_constants.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/external_donation_history_detail_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/widgets/donation_detail_row.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_past_date_picker.dart';
import 'package:givt_app/features/external_donations/detail/pages/external_donation_detail_page.dart';
import 'package:givt_app/features/external_donations/detail/widgets/external_donation_manage_list_item.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/donation_amount_validation.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class ExternalDonationHistoryDetailPage extends StatefulWidget {
  const ExternalDonationHistoryDetailPage({
    required this.donation,
    super.key,
  });

  final DonationItem donation;

  @override
  State<ExternalDonationHistoryDetailPage> createState() =>
      _ExternalDonationHistoryDetailPageState();
}

class _ExternalDonationHistoryDetailPageState
    extends State<ExternalDonationHistoryDetailPage> {
  late final ExternalDonationHistoryDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ExternalDonationHistoryDetailCubit>();
    _cubit.init(widget.donation);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onData: (context, uiModel) => FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: GivtBackButtonFlat(
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              onPressed: () => _showContactForm(context, uiModel.donation),
              icon: const FaIcon(FontAwesomeIcons.circleQuestion),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildHeaderIcon(context),
            const SizedBox(height: 16),
            TitleMediumText(
              uiModel.donation.organisationName,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            BodySmallText.secondary30(
              uiModel.isOneOff
                  ? context.l10n.donationHistoryExternalOneOffSubtitle
                  : context.l10n.donationHistoryExternalRecurringSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildDetailRows(context, uiModel),
            const Spacer(),
            if (uiModel.isOneOff)
              FunButton(
                text: context.l10n.donationHistoryExternalEditDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                onTap: () => _showOneOffEditSheet(context, uiModel),
                analyticsEvent: AnalyticsEventName
                    .donationHistoryExternalEditClicked
                    .toEvent(),
              )
            else ...[
              FunButton(
                text: context.l10n.donationHistoryExternalEditDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                onTap: () => _showOccurrenceEditSheet(context, uiModel),
                analyticsEvent: AnalyticsEventName
                    .donationHistoryExternalEditClicked
                    .toEvent(),
              ),
              const SizedBox(height: 12),
              FunButton(
                text: context.l10n.donationHistoryExternalManageRecurring,
                variant: FunButtonVariant.tertiary,
                onTap: () => _openManagePage(context),
                analyticsEvent: AnalyticsEventName
                    .donationHistoryExternalManageClicked
                    .toEvent(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(BuildContext context) {
    final theme = FunTheme.of(context);
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: theme.tertiary98,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.arrowUpRightFromSquare,
          color: theme.tertiary40,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildDetailRows(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel,
  ) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final country = Country.fromCode(auth.user.country);
    final donation = uiModel.donation;

    final rows = <Widget>[
      DonationDetailRow(
        label: context.l10n.donationHistoryExternalListSubtitle,
        value: '$currency${Util.formatNumberComma(donation.amount, country)}',
        showDivider: true,
      ),
      if (donation.timeStamp != null)
        DonationDetailRow(
          label: context.l10n.date,
          value: Util.formatFullDateLocal(
            donation.timeStamp!,
            Platform.localeName,
          ),
          showDivider: !uiModel.isOneOff && donation.externalFrequency != null,
        ),
      if (!uiModel.isOneOff && donation.externalFrequency != null)
        DonationDetailRow(
          label: context.l10n.discoverOrAmountActionSheetRecurring,
          value: ExternalDonationFrequencyDropdown.frequencyLabel(
            context.l10n,
            donation.externalFrequency!,
          ),
          showDivider: false,
        ),
    ];

    return Column(children: rows);
  }

  Future<void> _openManagePage(BuildContext context) async {
    final externalDonation = await _cubit.loadExternalDonationForManage();
    if (!context.mounted) {
      return;
    }
    if (externalDonation == null) {
      _showErrorSnackBar(context);
      return;
    }

    final didUpdate = await Navigator.of(context).push(
      ExternalDonationDetailPage(donation: externalDonation).toRoute(context),
    );
    if (didUpdate == true) {
      getIt<DonationOverviewCubit>().refreshDonations();
      if (context.mounted) {
        context.pop(true);
      }
    }
  }

  Future<void> _showOneOffEditSheet(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _OneOffEditSheet(
          uiModel: uiModel,
          onEditAmount: () {
            Navigator.of(sheetContext).pop();
            _showAmountEditor(context, uiModel, isOneOff: true);
          },
          onEditDate: () {
            Navigator.of(sheetContext).pop();
            _showDateEditor(context, uiModel);
          },
          onDelete: () {
            Navigator.of(sheetContext).pop();
            _showDeleteModal(context, uiModel);
          },
        );
      },
    );
  }

  Future<void> _showOccurrenceEditSheet(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _OccurrenceEditSheet(
          uiModel: uiModel,
          onEditAmount: () {
            Navigator.of(sheetContext).pop();
            _showAmountEditor(context, uiModel, isOneOff: false);
          },
          onDelete: () {
            Navigator.of(sheetContext).pop();
            _showDeleteModal(context, uiModel);
          },
        );
      },
    );
  }

  Future<void> _showAmountEditor(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel, {
    required bool isOneOff,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _AmountEditorSheet(
          uiModel: uiModel,
          isOneOff: isOneOff,
          onSave: (amount) async {
            Navigator.of(sheetContext).pop();
            if (isOneOff) {
              await _cubit.updateOneOffAmount(amount);
            } else {
              await _cubit.updateOccurrenceAmount(amount);
            }
          },
        );
      },
    );
  }

  Future<void> _showDateEditor(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _DateEditorSheet(
          uiModel: uiModel,
          onSave: (date) async {
            Navigator.of(sheetContext).pop();
            await _cubit.updateOneOffDate(date);
          },
        );
      },
    );
  }

  Future<void> _showDeleteModal(
    BuildContext context,
    ExternalDonationHistoryDetailUIModel uiModel,
  ) {
    final locals = context.l10n;
    return FunModal(
      icon: FunIcon.trash(),
      title: locals.externalDonationsDeleteModalTitle(
        uiModel.donation.organisationName,
      ),
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () async {
            context.pop();
            if (uiModel.isOneOff) {
              await _cubit.deleteOneOff();
            } else {
              await _cubit.deleteOccurrence();
            }
          },
          text: locals.externalDonationsDeleteModalConfirm,
          variant: FunButtonVariant.destructiveSecondary,
          fullBorder: true,
          analyticsEvent: AnalyticsEventName.donationHistoryExternalDeleteClicked
              .toEvent(),
        ),
        FunButton(
          onTap: () => context.pop(),
          text: locals.externalDonationsDeleteModalCancel,
        ),
      ],
    ).show(context, isDismissible: true);
  }

  void _handleCustom(
    BuildContext context,
    ExternalDonationHistoryDetailCustom custom,
  ) {
    switch (custom) {
      case ExternalDonationHistoryMutationSucceeded():
        getIt<DonationOverviewCubit>().refreshDonations();
      case ExternalDonationHistoryMutationFailed():
        _showErrorSnackBar(context);
      case ExternalDonationHistoryDeleted():
        getIt<DonationOverviewCubit>().refreshDonations();
        context.pop(true);
    }
  }

  void _showContactForm(BuildContext context, DonationItem donation) {
    AboutGivtBottomSheet.show(
      context,
      initialMessage: context.l10n.donationOverviewContactMessage.replaceAll(
        r'\n',
        '\n',
      ),
      metadata: {
        'Flow': 'Donation history',
        'Donation type': 'External',
        'Organisation': donation.organisationName,
      },
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.somethingWentWrong),
        backgroundColor: FamilyAppTheme.error50,
      ),
    );
  }
}

class _OneOffEditSheet extends StatelessWidget {
  const _OneOffEditSheet({
    required this.uiModel,
    required this.onEditAmount,
    required this.onEditDate,
    required this.onDelete,
  });

  final ExternalDonationHistoryDetailUIModel uiModel;
  final VoidCallback onEditAmount;
  final VoidCallback onEditDate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.donationHistoryExternalEditDonation,
      closeAction: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          ExternalDonationManageListItem(
            icon: FontAwesomeIcons.moneyBillWave,
            label: locals.externalDonationsManageAmount,
            value: '',
            onTap: onEditAmount,
          ),
          ExternalDonationManageListItem(
            icon: FontAwesomeIcons.solidCalendar,
            label: locals.externalDonationsDetailOneOffDate,
            value: '',
            onTap: onEditDate,
          ),
          ExternalDonationManageListItem(
            icon: FontAwesomeIcons.trash,
            label: locals.externalDonationsManageDeleteDonation,
            value: '',
            onTap: onDelete,
            analyticsEvent: AnalyticsEventName
                .donationHistoryExternalDeleteClicked
                .toEvent(),
          ),
        ],
      ),
    );
  }
}

class _OccurrenceEditSheet extends StatelessWidget {
  const _OccurrenceEditSheet({
    required this.uiModel,
    required this.onEditAmount,
    required this.onDelete,
  });

  final ExternalDonationHistoryDetailUIModel uiModel;
  final VoidCallback onEditAmount;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.donationHistoryExternalEditDonation,
      closeAction: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          ExternalDonationManageListItem(
            icon: FontAwesomeIcons.moneyBillWave,
            label: locals.externalDonationsManageAmount,
            value: '',
            onTap: onEditAmount,
          ),
          ExternalDonationManageListItem(
            icon: FontAwesomeIcons.trash,
            label: locals.externalDonationsManageDeleteDonation,
            value: '',
            onTap: onDelete,
            analyticsEvent: AnalyticsEventName
                .donationHistoryExternalDeleteClicked
                .toEvent(),
          ),
        ],
      ),
    );
  }
}

class _AmountEditorSheet extends StatefulWidget {
  const _AmountEditorSheet({
    required this.uiModel,
    required this.isOneOff,
    required this.onSave,
  });

  final ExternalDonationHistoryDetailUIModel uiModel;
  final bool isOneOff;
  final Future<void> Function(double amount) onSave;

  @override
  State<_AmountEditorSheet> createState() => _AmountEditorSheetState();
}

class _AmountEditorSheetState extends State<_AmountEditorSheet> {
  late final TextEditingController _amountController;
  late final String _initialAmountInput;
  late final Country _country;

  @override
  void initState() {
    super.initState();
    _country = Country.fromCode(
      context.read<AuthCubit>().state.user.country,
    );
    _initialAmountInput =
        Util.formatNumberComma(widget.uiModel.donation.amount, _country);
    _amountController = TextEditingController(text: _initialAmountInput);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSave {
    return DonationAmountValidation.isPositiveWithinInputLimit(
          _amountController.text,
        ) &&
        _amountController.text.trim() != _initialAmountInput.trim();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final currency =
        Util.getCurrencySymbol(countryCode: context.read<AuthCubit>().state.user.country);

    return FunBottomSheet(
      title: locals.externalDonationsManageAmount,
      closeAction: () => Navigator.of(context).pop(),
      content: FunInput(
        label: locals.externalDonationsManageAmount,
        controller: _amountController,
        prefixText: currency,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(Util.numberInputFieldRegExp()),
          LengthLimitingTextInputFormatter(
            DonationAmountConstants.maxIntegerDigits + 3,
          ),
        ],
        onChanged: (_) => setState(() {}),
      ),
      primaryButton: FunButton(
        text: locals.externalDonationsSave,
        isDisabled: !_canSave,
        isLoading: widget.uiModel.isSaving,
        analyticsEvent:
            AnalyticsEventName.donationHistoryExternalEditSaveClicked.toEvent(),
        onTap: _canSave && !widget.uiModel.isSaving
            ? () async {
                final amount = DonationAmountValidation.parseAmount(
                  _amountController.text,
                );
                if (amount == null) {
                  return;
                }
                await widget.onSave(amount);
              }
            : null,
      ),
    );
  }
}

class _DateEditorSheet extends StatefulWidget {
  const _DateEditorSheet({
    required this.uiModel,
    required this.onSave,
  });

  final ExternalDonationHistoryDetailUIModel uiModel;
  final Future<void> Function(DateTime date) onSave;

  @override
  State<_DateEditorSheet> createState() => _DateEditorSheetState();
}

class _DateEditorSheetState extends State<_DateEditorSheet> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.uiModel.donation.timeStamp;
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final initialDate = widget.uiModel.donation.timeStamp;
    final hasChanged = _selectedDate != null &&
        (initialDate == null ||
            _selectedDate!.year != initialDate.year ||
            _selectedDate!.month != initialDate.month ||
            _selectedDate!.day != initialDate.day);

    return FunBottomSheet(
      title: locals.externalDonationsDetailOneOffDate,
      closeAction: () => Navigator.of(context).pop(),
      content: ExternalDonationPastDatePicker(
        label: locals.externalDonationsDetailOneOffDate,
        selectedDate: _selectedDate,
        onDateSelected: (date) => setState(() => _selectedDate = date),
      ),
      primaryButton: FunButton(
        text: locals.externalDonationsSave,
        isDisabled: !hasChanged,
        isLoading: widget.uiModel.isSaving,
        analyticsEvent:
            AnalyticsEventName.donationHistoryExternalEditSaveClicked.toEvent(),
        onTap: hasChanged && !widget.uiModel.isSaving && _selectedDate != null
            ? () => widget.onSave(_selectedDate!)
            : null,
      ),
    );
  }
}
