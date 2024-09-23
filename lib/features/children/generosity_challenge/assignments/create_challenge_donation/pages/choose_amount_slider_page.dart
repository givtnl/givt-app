import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/cubit/create_challenge_donation_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/organisation_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/widgets/slider_widget.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_striple_registration_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_initial_dialog.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChooseAmountSliderPage extends StatefulWidget {
  const ChooseAmountSliderPage({
    required this.organisation,
    super.key,
  });

  final Organisation organisation;

  @override
  State<ChooseAmountSliderPage> createState() => _ChooseAmountSliderPageState();
}

class _ChooseAmountSliderPageState extends State<ChooseAmountSliderPage> {
  bool _isLoading = false;
  final give = getIt<GiveBloc>();
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
          bloc: give,
          listener: (context, giveState) async {
            if (giveState.status == GiveStatus.processed) {
              _setLoading(false);
              context.read<GenerosityChallengeCubit>()
                ..confirmAssignment(
                  _createAssignmentDescription(
                    widget.organisation.organisationName!,
                    state.amount,
                  ),
                )
                ..saveUserDataByKey(
                  ChatScriptSaveKey.organisation,
                  widget.organisation.organisationName!,
                );
              context.goNamed(FamilyPages.generosityChallenge.name);
              _logSuccessFullDonation(state);
            } else if (giveState.status == GiveStatus.error) {
              _setLoading(false);
              NoFundsInitialDialog.show(context);
            }
          },
          child: Scaffold(
            appBar: FunTopAppBar.primary99(
              title: 'Day 7',
              leading: const GenerosityBackButton(),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            OrganisationWidget(widget.organisation),
                            const Spacer(),
                            Text(
                              'How much would you like to give?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
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
                        maxAmount:
                            CreateChallengeDonationState.maxAvailableAmount,
                      ),
                      const Spacer(),
                    ],
                  ),
                  if (_isLoading)
                    const Align(
                      child: CustomCircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FunButton(
              isDisabled: state.amount == 0 || _isLoading,
              text: 'Donate',
              onTap: () async {
                try {
                  _setLoading(true);
                  final stripeResponse =
                      await getIt<GenerosityStripeRegistrationCubit>()
                          .setupStripeRegistration();
                  if (context.mounted) {
                    await StripeHelper(context)
                        .showPaymentSheet(stripe: stripeResponse)
                        .then((value) {
                      _handleStripeRegistrationSuccess(context, state);
                    }).onError((e, stackTrace) {
                      _handleStripeOrDonationError(context, e, stackTrace);
                    });
                  } else {
                    throw Exception(
                      'Context is not mounted after stripe registration.',
                    );
                  }
                } catch (e, stackTrace) {
                  if (context.mounted) {
                    _handleStripeOrDonationError(context, e, stackTrace);
                  }
                }
              },
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.chooseAmountDonateClicked,
                parameters: {
                  'organisation_name': widget.organisation.organisationName,
                  'amount': state.amount.toInt(),
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _logSuccessFullDonation(CreateChallengeDonationState state) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.generosityChallengeDonationSuccess,
      eventProperties: {
        'organisation_name': widget.organisation.organisationName,
        'amount': state.amount,
      },
    );
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _handleStripeRegistrationSuccess(
    BuildContext context,
    CreateChallengeDonationState state,
  ) {
    final decodedMediumId =
        utf8.decode(base64.decode(widget.organisation.mediumId!));

    give
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

  void _handleStripeOrDonationError(
    BuildContext context,
    Object? e,
    StackTrace stackTrace,
  ) {
    _setLoading(false);
    if (e is StripeException && e.error.code == FailureCode.Canceled) {
      // do nothing
    } else {
      give.add(const GiveStripeRegistrationError());
      LoggingInfo.instance.info(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }
  }
}
