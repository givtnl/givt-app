import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/review_donations/utils/navigation_helper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class SignBacsMandatePage extends StatelessWidget {
  const SignBacsMandatePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final registrationState = context.watch<RegistrationBloc>().state;

    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.signMandateTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == RegistrationStatus.bacsDirectDebitMandateSigned) {
            navigateAfterMandateSigning(context, user.country);
          }
          if (state.status == RegistrationStatus.bacsDetailsWrong) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.mandateFailed,
                content: locals.updateBacsAccountDetailsError,
                onConfirm: () => context.goNamed(Pages.home.name),
              ),
            );
          }

          if (state.status == RegistrationStatus.ddiFailed) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.ddiFailedTitle,
                content: locals.ddiFailedMessage,
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
        child: Column(
          children: [
            Expanded(
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
                                    value: user.sortCode,
                                    icon: const Icon(
                                      FontAwesomeIcons.buildingColumns,
                                      color: FamilyAppTheme.tertiary40,
                                      size: 18,
                                    ),
                                  ),
                                  _buildInforRow(
                                    value: user.accountNumber,
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
                              locals.bacsVerifyBody,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FunButton(
              variant: FunButtonVariant.secondary,
              fullBorder: true,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                builder: (BuildContext context) => TermsAndConditionsDialog(
                  content: locals.bacsDdGuarantee,
                ),
              ),
              text: locals.bacsReadDdGuarantee,
              analyticsEvent: AmplitudeEvents.infoGivingAllowanceClicked
                  .toEvent(),
            ),
            const SizedBox(height: 16),
            FunButton(
              onTap: registrationState.status == RegistrationStatus.loading
                  ? null
                  : () => context.read<RegistrationBloc>().add(
                      RegistrationSignMandate(
                        guid: user.guid,
                        appLanguage: locals.localeName,
                      ),
                    ),
              isLoading: registrationState.status == RegistrationStatus.loading,
              text: locals.buttonContinue,
              analyticsEvent: AmplitudeEvents.continueClicked.toEvent(),
            ),
          ],
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
