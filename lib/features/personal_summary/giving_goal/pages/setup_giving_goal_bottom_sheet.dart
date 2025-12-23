import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/models/giving_goal.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class SetupGivingGoalBottomSheet extends StatefulWidget {
  const SetupGivingGoalBottomSheet({
    super.key,
  });

  @override
  State<SetupGivingGoalBottomSheet> createState() =>
      _SetupGivingGoalBottomSheetState();
}

class _SetupGivingGoalBottomSheetState
    extends State<SetupGivingGoalBottomSheet> {
  late TextEditingController amountController;
  late GivingGoalFrequency frequency;

  @override
  void initState() {
    final personalSummaryState = context.read<PersonalSummaryBloc>().state;
    final givingGoal = personalSummaryState.givingGoal;
    amountController = TextEditingController(
      text: givingGoal.amount.toString(),
    );
    frequency = givingGoal.frequency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final country = Country.fromCode(userCountry);
    final personalSummaryState = context.watch<PersonalSummaryBloc>().state;

    return BottomSheetLayout(
      title: Text(locals.budgetGivingGoalTitle),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: personalSummaryState.givingGoal.monthlyGivingGoal != 0,
            child: TextButton(
              onPressed: () {
                context
                    .read<PersonalSummaryBloc>()
                    .add(const PersonalSummaryGoalRemove());

                AnalyticsHelper.logEvent(
                  eventName: AnalyticsEventName.removeGivingGoalClicked,
                );
              },
              child: Text(
                locals.budgetGivingGoalRemove,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppTheme.givtPurple,
                    ),
              ),
            ),
          ),
          Visibility(
            visible:
                personalSummaryState.status == PersonalSummaryStatus.loading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Visibility(
            visible:
                personalSummaryState.status != PersonalSummaryStatus.loading,
            child: ElevatedButton(
              onPressed: isEnabled ? () => onSave(context) : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                locals.save,
              ),
            ),
          ),
        ],
      ),
      child: BlocListener<PersonalSummaryBloc, PersonalSummaryState>(
        listener: (context, state) {
          if (state.status == PersonalSummaryStatus.noInternet) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.noInternetConnectionTitle,
                content: locals.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }

          if (state.status == PersonalSummaryStatus.success) {
            context.pop();
          }
        },
        child: Column(
          children: [
            CardBanner(
              title: locals.budgetGivingGoalInfoBold,
              subtitle: locals.budgetGivingGoalInfo,
            ),
            _buildFieldTitle(locals.budgetGivingGoalMine),
            _buildTextField(context, country),
            _buildFieldTitle(locals.budgetGivingGoalTime),
            _buildPeriodDropdown(context: context),
          ],
        ),
      ),
    );
  }

  /// Build the text field for the amount
  Widget _buildTextField(
    BuildContext context,
    Country country,
  ) {
    final locals = context.l10n;
    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      controller: amountController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          Util.numberInputFieldRegExp(),
        ),
      ],
      onChanged: (value) => setState(() {}),
      validator: (newValue) {
        if (newValue == null) {
          return '';
        }
        final amount = int.parse(newValue);
        if (amount <= 0 || amount > 99999) {
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: locals.budgetExternalGiftsAmount,
        hintText: locals.budgetExternalGiftsAmount,
        prefixIcon: Icon(
          Util.getCurrencyIconData(country: country),
        ),
      ),
    );
  }

  /// Build the dropdown for the period
  Widget _buildPeriodDropdown({
    required BuildContext context,
  }) {
    final locals = context.l10n;
    final frequencies = [
      GivingGoalFrequency.monthly,
      GivingGoalFrequency.annually,
    ];
    return DropdownButtonFormField<GivingGoalFrequency>(
      hint: Text(locals.budgetExternalGiftsTime),
      value: frequency,
      onChanged: (GivingGoalFrequency? newValue) {
        if (newValue == null) {
          return;
        }
        setState(() {
          frequency = newValue;
        });
      },
      items: frequencies
          .map<DropdownMenuItem<GivingGoalFrequency>>(
            (GivingGoalFrequency value) => DropdownMenuItem<GivingGoalFrequency>(
              value: value,
              alignment: Alignment.centerLeft,
              child: Text(
                value == GivingGoalFrequency.monthly
                    ? locals.budgetSummaryMonth
                    : locals.budgetSummaryYear,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  bool get isEnabled {
    return amountController.text.isNotEmpty;
  }

  void onSave(BuildContext context) {
    context.read<PersonalSummaryBloc>().add(
          PersonalSummaryGoalAdd(
            amount: int.parse(amountController.text),
            frequency: frequency,
          ),
        );

    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.givingGoalSaved,
      eventProperties: {
        'amount': amountController.text,
        'frequency': frequency,
      },
    );
  }

  Widget _buildFieldTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
