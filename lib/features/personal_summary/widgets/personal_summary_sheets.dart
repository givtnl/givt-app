import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/cubit/personal_summary_cubit.dart';
import 'package:givt_app/features/personal_summary/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/utils/utils.dart';

enum _AddDonationOption { giveThroughGivt, addExternal }

class AddDonationBottomSheet extends StatefulWidget {
  const AddDonationBottomSheet({
    required this.onGiveThroughGivt,
    required this.onAddExternalDonation,
    super.key,
  });

  final VoidCallback onGiveThroughGivt;
  final VoidCallback onAddExternalDonation;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGiveThroughGivt,
    required VoidCallback onAddExternalDonation,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      builder: (_) => AddDonationBottomSheet(
        onGiveThroughGivt: onGiveThroughGivt,
        onAddExternalDonation: onAddExternalDonation,
      ),
    );
  }

  @override
  State<AddDonationBottomSheet> createState() => _AddDonationBottomSheetState();
}

class _AddDonationBottomSheetState extends State<AddDonationBottomSheet> {
  _AddDonationOption? _selected;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);

    return FunBottomSheet(
      title: locals.personalSummaryAddDonationSheetTitle,
      titleColor: theme.secondary30,
      closeAction: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          const SizedBox(height: 16),
          _AddDonationOptionRow(
            title: locals.personalSummaryGiveThroughGivt,
            subtitle: locals.personalSummaryGiveThroughGivtSubtitle,
            isSelected: _selected == _AddDonationOption.giveThroughGivt,
            onTap: () => setState(
              () => _selected = _AddDonationOption.giveThroughGivt,
            ),
          ),
          _AddDonationOptionRow(
            title: locals.personalSummaryAddExternalDonation,
            subtitle: locals.personalSummaryAddExternalDonationSubtitle,
            isSelected: _selected == _AddDonationOption.addExternal,
            onTap: () => setState(
              () => _selected = _AddDonationOption.addExternal,
            ),
            showDivider: false,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: locals.buttonContinue,
        isDisabled: _selected == null,
        analyticsEvent: AnalyticsEvent(
          AnalyticsEventName.personalSummaryAddDonationContinueClicked,
        ),
        onTap: _selected == null
            ? null
            : () {
                Navigator.of(context).pop();
                switch (_selected!) {
                  case _AddDonationOption.giveThroughGivt:
                    widget.onGiveThroughGivt();
                  case _AddDonationOption.addExternal:
                    widget.onAddExternalDonation();
                }
              },
      ),
    );
  }
}

class _AddDonationOptionRow extends StatelessWidget {
  const _AddDonationOptionRow({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: showDivider
                    ? theme.neutralVariant95
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelMediumText(title, color: theme.primary20),
                    const SizedBox(height: 4),
                    BodySmallText(subtitle, color: theme.neutral50),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FaIcon(
                isSelected
                    ? FontAwesomeIcons.solidCircleCheck
                    : FontAwesomeIcons.circle,
                size: 20,
                color: isSelected
                    ? theme.primary40
                    : theme.primary30.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GivingGoalBottomSheet extends StatefulWidget {
  const GivingGoalBottomSheet({
    required this.cubit,
    required this.initialGoal,
    required this.countryCode,
    super.key,
  });

  final PersonalSummaryCubit cubit;
  final GivingGoal initialGoal;
  final String countryCode;

  static Future<void> show(
    BuildContext context, {
    required PersonalSummaryCubit cubit,
    required GivingGoal initialGoal,
    required String countryCode,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      isDismissible: !cubit.isSavingGoal,
      builder: (_) => GivingGoalBottomSheet(
        cubit: cubit,
        initialGoal: initialGoal,
        countryCode: countryCode,
      ),
    );
  }

  @override
  State<GivingGoalBottomSheet> createState() => _GivingGoalBottomSheetState();
}

class _GivingGoalBottomSheetState extends State<GivingGoalBottomSheet> {
  late final TextEditingController _amountController;
  late GivingGoalFrequency _frequency;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialGoal.hasGoal
          ? widget.initialGoal.amount.toString()
          : '',
    );
    _frequency = widget.initialGoal.frequency;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSave {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      return false;
    }
    final amount = int.tryParse(text);
    return amount != null && amount > 0 && amount <= 99999;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        PersonalSummaryCubit,
        BaseState<PersonalSummaryUIModel, PersonalSummaryCustom>>(
      bloc: widget.cubit,
      builder: (context, state) {
        final isSaving = widget.cubit.isSavingGoal;
        return PopScope(
          canPop: !isSaving,
          child: _GivingGoalSheetContent(
            isSaving: isSaving,
            amountController: _amountController,
            frequency: _frequency,
            initialGoal: widget.initialGoal,
            countryCode: widget.countryCode,
            onFrequencyChanged: isSaving
                ? null
                : (value) => setState(() => _frequency = value),
            onAmountChanged: (_) => setState(() {}),
            onRemove: () async {
              final success = await widget.cubit.removeGivingGoal();
              if (context.mounted && success) {
                Navigator.of(context).pop();
              }
            },
            onSave: () async {
              final success = await widget.cubit.saveGivingGoal(
                amount: int.parse(_amountController.text.trim()),
                frequency: _frequency,
              );
              if (context.mounted && success) {
                Navigator.of(context).pop();
              }
            },
            canSave: _canSave,
          ),
        );
      },
    );
  }
}

class _GivingGoalSheetContent extends StatelessWidget {
  const _GivingGoalSheetContent({
    required this.isSaving,
    required this.amountController,
    required this.frequency,
    required this.initialGoal,
    required this.countryCode,
    required this.onFrequencyChanged,
    required this.onAmountChanged,
    required this.onRemove,
    required this.onSave,
    required this.canSave,
  });

  final bool isSaving;
  final TextEditingController amountController;
  final GivingGoalFrequency frequency;
  final GivingGoal initialGoal;
  final String countryCode;
  final ValueChanged<GivingGoalFrequency>? onFrequencyChanged;
  final ValueChanged<String> onAmountChanged;
  final Future<void> Function() onRemove;
  final Future<void> Function() onSave;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final currencySymbol = Util.getCurrencySymbol(countryCode: countryCode);

    return FunBottomSheet(
      title: locals.budgetGivingGoalTitle,
      closeAction: isSaving ? null : () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BodyMediumText(locals.budgetGivingGoalInfo),
          const SizedBox(height: 16),
          FunInput(
            controller: amountController,
            label: locals.budgetGivingGoalMine,
            hintText: locals.budgetExternalGiftsAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(Util.numberInputFieldRegExp()),
            ],
            onChanged: onAmountChanged,
            prefixText: currencySymbol,
            readOnly: isSaving,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GivingGoalFrequency>(
            value: frequency,
            decoration: InputDecoration(
              labelText: locals.budgetGivingGoalTime,
            ),
            items: [
              DropdownMenuItem(
                value: GivingGoalFrequency.monthly,
                child: Text(locals.budgetSummaryMonth),
              ),
              DropdownMenuItem(
                value: GivingGoalFrequency.annually,
                child: Text(locals.budgetSummaryYear),
              ),
            ],
            onChanged: onFrequencyChanged == null
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }
                    onFrequencyChanged!(value);
                  },
          ),
          if (initialGoal.hasGoal) ...[
            const SizedBox(height: 16),
            FunButton(
              text: locals.budgetGivingGoalRemove,
              variant: FunButtonVariant.tertiary,
              isDisabled: isSaving,
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.removeGivingGoalClicked,
              ),
              onTap: isSaving ? null : onRemove,
            ),
          ],
        ],
      ),
      primaryButton: FunButton(
        text: locals.save,
        isLoading: isSaving,
        isDisabled: !canSave || isSaving,
        analyticsEvent: AnalyticsEvent(
          AnalyticsEventName.givingGoalSaved,
        ),
        onTap: !canSave || isSaving ? null : onSave,
      ),
    );
  }
}
