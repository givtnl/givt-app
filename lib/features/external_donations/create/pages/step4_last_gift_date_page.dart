import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_flow_step.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_ui_model.dart';
import 'package:givt_app/features/external_donations/create/pages/step5_start_month_year_page.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_close_modal.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_helper.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_step_shell.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class Step4LastGiftDatePage extends StatelessWidget {
  const Step4LastGiftDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ExternalDonationCreateCubit>();
    final locals = context.l10n;

    return BaseStateConsumer<ExternalDonationCreateUIModel,
        ExternalDonationCreateCustom>(
      cubit: cubit,
      onCustom: (context, action) {
        switch (action) {
          case NavigateToStartMonthYear():
            Navigator.of(context).push(
              const Step5StartMonthYearPage().toRoute(context),
            );
          case _:
            break;
        }
      },
      onData: (context, uiModel) {
        final draft = uiModel.draft;
        final frequencyLabel = draft.frequency != null
            ? ExternalDonationFrequencyDropdown.frequencyLabel(
                locals,
                draft.frequency!,
              )
            : '';

        return ExternalDonationCreateStepShell(
          title: locals.externalDonationsCreateTitle,
          currentStep: 2,
          stepCount: uiModel.stepCount,
          onClose: () => const ExternalDonationCreateCloseModal().show(context),
          preview: externalDonationCreatePreviewForStep(
            context,
            uiModel,
            ExternalDonationCreateFlowStep.lastGiftDate,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExternalDonationStepDescription(
                text: locals.externalDonationsCreateLastGiftDescriptionWithOrg(
                  frequencyLabel,
                  draft.organisationName,
                ),
              ),
              const SizedBox(height: 32),
              _PastDatePicker(
                label: locals.externalDonationsCreateLastGiftLabel,
                selectedDate: draft.lastGiftDate,
                onDateSelected: cubit.updateLastGiftDate,
              ),
            ],
          ),
          bottom: FunButton(
            text: locals.buttonContinue,
            isDisabled: !draft.isLastGiftDateValid,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateLastGiftContinueClicked
                .toEvent(),
            onTap: draft.isLastGiftDateValid
                ? cubit.continueFromLastGiftDate
                : null,
          ),
        );
      },
    );
  }
}

class _PastDatePicker extends StatefulWidget {
  const _PastDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;

  @override
  State<_PastDatePicker> createState() => _PastDatePickerState();
}

class _PastDatePickerState extends State<_PastDatePicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncControllerText();
  }

  @override
  void didUpdateWidget(_PastDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _syncControllerText();
    }
  }

  void _syncControllerText() {
    final newText = _formatDisplay();
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  String _formatDisplay() {
    if (widget.selectedDate == null) {
      return '';
    }
    return MaterialLocalizations.of(context)
        .formatMediumDate(widget.selectedDate!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunInput(
      label: widget.label,
      controller: _controller,
      readOnly: true,
      hintText: context.l10n.externalDonationsCreateSelectDateHint,
      suffixIcon: Icon(Icons.calendar_today, color: FunTheme.of(context).neutral40),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? now,
          firstDate: DateTime(now.year - 30),
          lastDate: now,
        );
        if (picked != null) {
          widget.onDateSelected(picked);
        }
      },
    );
  }
}
