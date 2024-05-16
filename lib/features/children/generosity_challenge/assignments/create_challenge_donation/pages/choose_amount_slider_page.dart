import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/cubit/create_challenge_donation_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/organisation_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/slider_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class ChooseAmountSliderPage extends StatelessWidget {
  const ChooseAmountSliderPage({
    required this.organisation,
    super.key,
  });

  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChallengeDonationCubit,
        CreateChallengeDonationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const GenerosityAppBar(
            title: 'Day 7',
            leading: GenerosityBackButton(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      OrganisationWidget(organisation),
                      const Spacer(),
                      Text(
                        'How much would you like to give?',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.primary20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Rouna',
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                SliderWidget(
                  currentAmount: state.amount,
                  maxAmount: CreateChallengeDonationState.maxAvailableAmount,
                ),
                const Spacer(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: GivtElevatedButton(
            isDisabled: state.amount == 0,
            text: 'Donate',
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.chooseAmountDonateClicked,
                eventProperties: {
                  'organisation_name': organisation.organisationName,
                  'amount': state.amount.toInt(),
                },
              );
              //TODO: create transaction (kids-946)
            },
          ),
        );
      },
    );
  }
}
