import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/cubit/create_challenge_donation_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/organisation_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/slider_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_striple_registration_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_initial_dialog.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/dialogs/give_loading_dialog.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChooseAmountSliderPage extends StatelessWidget {
  const ChooseAmountSliderPage({
    required this.organisation,
    super.key,
  });

  final Organisation organisation;

  String _createAssignmentDescription(String organisationName, double amount) {
    final intAmount = amount.toInt();
    return 'You gave $intAmount dollar${intAmount > 1 ? 's' : ''} to the $organisationName. Awesome!';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChallengeDonationCubit,
        CreateChallengeDonationState>(
      builder: (context, state) {
        return BlocListener<GiveBloc, GiveState>(
          listener: (context, giveState) {
            if (giveState.status == GiveStatus.processed ||
                giveState.status == GiveStatus.error) {
              context.read<GenerosityChallengeCubit>()
                ..confirmAssignment(
                  _createAssignmentDescription(
                    organisation.organisationName!,
                    state.amount,
                  ),
                )
                ..saveUserDataByKey(
                  ChatScriptSaveKey.organisation,
                  organisation.organisationName!,
                );
              context.goNamed(Pages.generosityChallenge.name);
            }
          },
          child: Scaffold(
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
              onTap: () async {
                _logDonationAnalytics(state);
                try {
                  final stripeResponse =
                      await getIt<GenerosityStripeRegistrationCubit>()
                          .setupStripeRegistration();
                  if (context.mounted) {
                    await StripeHelper(context)
                        .showPaymentSheet(stripe: stripeResponse)
                        .then((value) {
                      _handleStripeRegistrationSuccess(context, state);
                    }).onError((e, stackTrace) {
                      _handleStripeError(context, e, stackTrace);
                    });
                  } else {
                    throw Exception(
                      'Context is not mounted after stripe registration.',
                    );
                  }
                } catch (e, stackTrace) {
                  if (context.mounted) {
                    _handleStripeError(context, e, stackTrace);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _logDonationAnalytics(CreateChallengeDonationState state) {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.chooseAmountDonateClicked,
        eventProperties: {
          'organisation_name': organisation.organisationName,
          'amount': state.amount.toInt(),
        },
      ),
    );
  }

  void _handleStripeRegistrationSuccess(
    BuildContext context,
    CreateChallengeDonationState state,
  ) {
    unawaited(GiveLoadingDialog.showGiveLoadingDialog(context));

    final decodedMediumId = utf8.decode(base64.decode(organisation.mediumId!));

    context.read<GiveBloc>()
      ..add(
        GiveAmountChanged(
          firstCollectionAmount: state.amount,
          secondCollectionAmount: 0,
          thirdCollectionAmount: 0,
        ),
      )
      ..add(
        GiveOrganisationSelected(
          nameSpace: decodedMediumId,
          userGUID: context.read<AuthCubit>().state.user.guid,
        ),
      );
  }

  void _handleStripeError(
      BuildContext context, Object? e, StackTrace stackTrace) {
    NoFundsInitialDialog.show(context);
    LoggingInfo.instance.info(
      e.toString(),
      methodName: stackTrace.toString(),
    );
  }
}
