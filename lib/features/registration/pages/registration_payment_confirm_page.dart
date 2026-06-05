import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/personal_info_edit_sheets.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/creditcard_setup/pages/credit_card_details.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/sign_mandate_detail_row.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

/// US registration: confirm saved details before opening Stripe.
///
/// Personal info is already persisted; Continue only starts payment setup.
class RegistrationPaymentConfirmPage extends StatefulWidget {
  const RegistrationPaymentConfirmPage({super.key});

  @override
  State<RegistrationPaymentConfirmPage> createState() =>
      _RegistrationPaymentConfirmPageState();
}

class _RegistrationPaymentConfirmPageState
    extends State<RegistrationPaymentConfirmPage> {
  bool _stripeFlowInProgress = false;
  bool _navigatedToAccountSetup = false;

  void _releaseStripeFlow() {
    if (!_stripeFlowInProgress) return;
    setState(() => _stripeFlowInProgress = false);
  }

  bool get _canStartStripeFlow {
    final status = context.read<RegistrationBloc>().state.status;
    return !_stripeFlowInProgress &&
        status != RegistrationStatus.finalizingAccount &&
        status != RegistrationStatus.success;
  }

  Future<void> _openStripeSheet() async {
    if (!_canStartStripeFlow) return;
    setState(() => _stripeFlowInProgress = true);

    await CreditCardDetails.show(
      context,
      onSuccess: () {},
      onFlowEnded: _releaseStripeFlow,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;

    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.signMandateConfirmTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == RegistrationStatus.finalizingAccount &&
              !_navigatedToAccountSetup) {
            _navigatedToAccountSetup = true;
            context.pushReplacementNamed(
              Pages.registrationAccountSetup.name,
              extra: context.read<RegistrationBloc>(),
            );
          }
          if (state.status == RegistrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(locals.registrationErrorTitle),
              ),
            );
            setState(() {
              _stripeFlowInProgress = false;
              _navigatedToAccountSetup = false;
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SignMandateDetailRow(
                      label: locals.signMandateRowAccountHolder,
                      value: '${user.firstName} ${user.lastName}',
                      leadingIcon: FontAwesomeIcons.solidUser,
                      leadingIconColor: FamilyAppTheme.primary40,
                      showEdit: true,
                      onEdit: () {
                        AnalyticsHelper.logEvent(
                          eventName: AnalyticsEventName.onInfoRowClicked,
                          eventProperties: const {'row_type': 'name'},
                        );
                        showChangeNameSheetForUser(context, user);
                      },
                    ),
                    SignMandateDetailRow(
                      label: locals.signMandateRowEmail,
                      value: user.email,
                      leadingIcon: FontAwesomeIcons.solidEnvelope,
                      leadingIconColor: FamilyAppTheme.primary40,
                      showEdit: true,
                      onEdit: () {
                        AnalyticsHelper.logEvent(
                          eventName: AnalyticsEventName.onInfoRowClicked,
                          eventProperties: const {'row_type': 'email'},
                        );
                        showChangeEmailSheetForUser(context, user);
                      },
                    ),
                    SignMandateDetailRow(
                      label: locals.signMandateRowAddress,
                      value:
                          '${user.address} ${user.postalCode} ${user.city}, '
                          '${Country.getCountry(user.country, locals)}',
                      leadingIcon: FontAwesomeIcons.solidHouse,
                      leadingIconColor: FamilyAppTheme.primary40,
                      showEdit: true,
                      onEdit: () {
                        AnalyticsHelper.logEvent(
                          eventName: AnalyticsEventName.onInfoRowClicked,
                          eventProperties: const {'row_type': 'address'},
                        );
                        showChangeAddressSheetForUser(context, user);
                      },
                    ),
                    SignMandateDetailRow(
                      label: locals.phoneNumber,
                      value: user.phoneNumber,
                      leadingIcon: FontAwesomeIcons.phone,
                      leadingIconColor: FamilyAppTheme.primary40,
                      showEdit: true,
                      onEdit: () {
                        AnalyticsHelper.logEvent(
                          eventName: AnalyticsEventName.onInfoRowClicked,
                          eventProperties: const {'row_type': 'phone'},
                        );
                        showChangePhoneSheetForUser(context, user);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BodyMediumText(
              locals.registrationPaymentConfirmFooter,
              textAlign: TextAlign.left,
              color: FunTheme.of(context).primary20,
            ),
            const SizedBox(height: 16),
            FunButton(
              onTap: _canStartStripeFlow ? _openStripeSheet : null,
              isDisabled: !_canStartStripeFlow,
              text: locals.enterPaymentDetails,
              analyticsEvent: AnalyticsEventName.continueClicked.toEvent(),
            ),
          ],
        ),
      ),
    );
  }
}
