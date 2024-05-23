import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/features/give/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoalAmountPage extends StatefulWidget {
  const CreateFamilyGoalAmountPage({
    required this.amount,
    super.key,
  });

  final num amount;

  @override
  State<CreateFamilyGoalAmountPage> createState() =>
      _CreateFamilyGoalAmountPageState();
}

class _CreateFamilyGoalAmountPageState
    extends State<CreateFamilyGoalAmountPage> {
  final _goalTargetController = TextEditingController();

  final focusNode = FocusNode();

  String _amountText = '';

  num get parsedAmount {
    return int.tryParse(_amountText) ?? 0;
  }

  @override
  void initState() {
    focusNode.requestFocus();
    if (widget.amount > 0) {
      _goalTargetController.text = _amountText = widget.amount.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _goalTargetController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      builder: (context, state) {
        final user = context.read<AuthCubit>().state.user;
        final currency = Util.getCurrency(countryCode: user.country);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              context.l10n.familyGoalAmountTitle,
              style: GoogleFonts.mulish(
                textStyle:
                    Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
              ),
            ),
            leading: BackButton(
              color: AppTheme.givtBlue,
              onPressed: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.backClicked,
                );
                context.read<CreateFamilyGoalCubit>().showCause();
              },
            ),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: FamilyGoalCreationStepper(
                    currentStep: FamilyGoalCreationStatus.amount,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          context.l10n.familyGoalHowMuch,
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.givtBlue,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _goalTargetController,
                          focusNode: focusNode,
                          maxLength: 4,
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                              locale: currency.locale,
                              decimalDigits: 0,
                              turnOffGrouping: true,
                              enableNegative: false,
                              symbol: currency.currencySymbol,
                            ),
                          ],
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _amountText =
                                  value.length > 1 ? value.substring(1) : value;
                            });
                          },
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppTheme.sliderIndicatorFilled,
                                  ),
                          decoration: InputDecoration(
                            hintText: '${currency.currencySymbol}0',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.childGivingAllowanceHint,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppTheme.inputFieldBorderEnabled,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppTheme.inputFieldBorderSelected,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          context.l10n.familyGoalAmountHint,
                          style: GoogleFonts.mulish(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.childGivingAllowanceHint,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 24,
                          right: 24,
                          bottom: 16,
                        ),
                        child: CustomGreenElevatedButton(
                          title: context.l10n.continueKey,
                          onPressed: parsedAmount > 0
                              ? () {
                                  context.read<CreateFamilyGoalCubit>()
                                    ..selectAmount(amount: parsedAmount)
                                    ..showConfirmation();
                                  AnalyticsHelper.logEvent(
                                    eventName:
                                        AmplitudeEvents.familyGoalAmountSet,
                                    eventProperties: {
                                      'amount': parsedAmount,
                                    },
                                  );
                                }
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
