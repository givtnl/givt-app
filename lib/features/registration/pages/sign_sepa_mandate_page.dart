import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/review_donations/utils/navigation_helper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class SignSepaMandatePage extends StatelessWidget {
  const SignSepaMandatePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final registrationState = context.watch<RegistrationBloc>().state;

    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: locals.signMandateTitle,
        leading: const GivtBackButtonFlat(),
      ),
      floatingActionButton: FunButton(
        onTap: registrationState.status == RegistrationStatus.loading
            ? null
            : () => context.read<RegistrationBloc>().add(
                  RegistrationSignMandate(
                    guid: user.guid,
                    appLanguage: locals.localeName,
                  ),
                ),
        isLoading: registrationState.status == RegistrationStatus.loading,
        text: locals.signMandate,
        analyticsEvent: AnalyticsEventName.continueClicked.toEvent(),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == RegistrationStatus.success) {
            navigateAfterMandateSigning(context, user.country);
          }
          if (state.status == RegistrationStatus.conflict) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.mandateFailed,
                content: locals.mandateFailPersonalInformation,
                onConfirm: () => context.goNamed(Pages.home.name),
              ),
            );
          }

          if (state.status == RegistrationStatus.badRequest) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.mandateFailed,
                content: locals.duplicateAccountOrganisationMessage,
                onConfirm: () => context.goNamed(Pages.home.name),
              ),
            );
          }

          if (state.status == RegistrationStatus.failure) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.mandateFailed,
                content: locals.mandateFailTryAgainLater,
                onConfirm: () => context.goNamed(Pages.home.name),
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      FunCard(
                        backgroundColor: FamilyAppTheme.neutralVariant99,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelLargeText(
                              locals.bacsVerifyTitle,
                            ),
                            const SizedBox(height: 8),
                            _buildInforRow(
                              value: '${user.firstName} ${user.lastName}',
                              icon: const Icon(
                                Icons.person,
                                color: FamilyAppTheme.primary40,
                                size: 20,
                              ),
                            ),
                            _buildInforRow(
                              value: user.email,
                              icon: const Icon(
                                Icons.alternate_email,
                                color: FamilyAppTheme.secondary40,
                                size: 20,
                              ),
                            ),
                            _buildInforRow(
                              value:
                                  '${user.address} ${user.postalCode} ${user.city}, ${user.country}',
                              icon: const Icon(
                                FontAwesomeIcons.house,
                                color: FamilyAppTheme.primary40,
                                size: 18,
                              ),
                            ),
                            _buildInforRow(
                              value: user.iban,
                              icon: const Icon(
                                FontAwesomeIcons.creditCard,
                                color: FamilyAppTheme.tertiary40,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      BodyMediumText(
                        locals.sepaVerifyBody,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      BodySmallText(
                        locals.signMandateDisclaimer,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInforRow({
    required String value,
    required Icon icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: LabelMediumText(
              value,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
