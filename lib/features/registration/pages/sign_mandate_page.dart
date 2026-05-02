import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/personal_info_edit_sheets.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/sign_mandate_detail_row.dart';
import 'package:givt_app/features/registration/widgets/sign_mandate_uk_dd_footer.dart';
import 'package:givt_app/features/review_donations/utils/navigation_helper.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/pages/flow_generic_error_extra.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

/// UK (BACS) and EU (SEPA) mandate confirmation.
///
/// Figma:
/// EU — https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49061-3973&m=dev
/// UK — https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49135-9140&m=dev
///
/// Uses [RegistrationBloc] for signing; [AuthCubit] for the current user.
/// Editable rows open the same account `showChange*` sheets as personal info.
class SignMandatePage extends StatelessWidget {
  const SignMandatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
    final registrationState = context.watch<RegistrationBloc>().state;
    final isUk = Country.unitedKingdomCodes().contains(user.country);
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.signMandateConfirmTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          _handleRegistrationStatus(context, state, user, locals);
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
                    if (isUk) ...[
                      SignMandateDetailRow(
                        label: locals.signMandateRowSortCode,
                        value: SortCodeTextFormatter.formatForDisplay(
                          user.sortCode,
                        ),
                        leadingIcon: FontAwesomeIcons.hashtag,
                        leadingIconColor: FamilyAppTheme.primary40,
                        showEdit: false,
                      ),
                      SignMandateDetailRow(
                        label: locals.signMandateRowBankAccountNumber,
                        value: user.accountNumber,
                        leadingIcon: FontAwesomeIcons.buildingColumns,
                        leadingIconColor: FamilyAppTheme.primary40,
                        showEdit: false,
                      ),
                    ] else
                      SignMandateDetailRow(
                        label: locals.signMandateRowBankDetails,
                        value: user.iban,
                        leadingIcon: FontAwesomeIcons.buildingColumns,
                        leadingIconColor: FamilyAppTheme.primary40,
                        showEdit: false,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isUk)
              SignMandateUkDdFooter(locals: locals)
            else
              BodyMediumText(
                locals.signMandateSepaFooter,
                textAlign: TextAlign.left,
                color: FunTheme.of(context).primary20,
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
              text: locals.signMandateLinkBankButton,
              analyticsEvent: AnalyticsEventName.continueClicked.toEvent(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegistrationStatus(
    BuildContext context,
    RegistrationState state,
    UserExt user,
    AppLocalizations locals,
  ) {
    if (state.status == RegistrationStatus.success ||
        state.status == RegistrationStatus.bacsDirectDebitMandateSigned) {
      navigateAfterMandateSigning(context, user.country);
      return;
    }

    final registrationBloc = context.read<RegistrationBloc>();
    final router = GoRouter.of(context);

    void pushError({
      required String title,
      required String message,
      required String errorReason,
    }) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        router.pushNamed(
          Pages.flowGenericError.name,
          extra: FlowGenericErrorExtra(
            screenTitle: locals.signMandateConfirmTitle,
            title: title,
            message: message,
            errorReason: errorReason,
            onTryAgain: () {
              registrationBloc.add(const RegistrationMandateErrorDismissed());
              router.pop();
            },
            onGoHome: () {
              registrationBloc.add(const RegistrationMandateErrorDismissed());
              router.goNamed(Pages.home.name);
            },
          ),
        );
      });
    }

    if (state.status == RegistrationStatus.conflict) {
      pushError(
        title: locals.mandateFailed,
        message: locals.mandateFailPersonalInformation,
        errorReason: 'conflict',
      );
    } else if (state.status == RegistrationStatus.badRequest) {
      pushError(
        title: locals.mandateFailed,
        message: locals.duplicateAccountOrganisationMessage,
        errorReason: 'bad_request',
      );
    } else if (state.status == RegistrationStatus.failure) {
      pushError(
        title: locals.mandateFailed,
        message: locals.mandateFailTryAgainLater,
        errorReason: 'failure',
      );
    } else if (state.status == RegistrationStatus.bacsDetailsWrong) {
      pushError(
        title: locals.mandateFailed,
        message: locals.updateBacsAccountDetailsError,
        errorReason: 'bacs_details_wrong',
      );
    } else if (state.status == RegistrationStatus.ddiFailed) {
      pushError(
        title: locals.ddiFailedTitle,
        message: locals.ddiFailedMessage,
        errorReason: 'ddi_failed',
      );
    }
  }
}
