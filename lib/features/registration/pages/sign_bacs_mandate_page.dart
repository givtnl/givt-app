import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SignBacsMandatePage extends StatelessWidget {
  const SignBacsMandatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final registrationBloc = context.read<RegistrationBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locals.bacsVerifyTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status ==
                RegistrationStatus.bacsDirectDebitMandateSigned) {
              context.goNamed(Pages.giftAid.name);
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
          builder: (context, state) {
            if (state.status == RegistrationStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Text(
                  locals.bacsVerifyBodyDetails(
                    '${user.firstName} ${user.lastName}',
                    '''${user.address}, ${user.postalCode} ${user.city} ${user.country}''',
                    user.email,
                    user.sortCode,
                    user.accountNumber,
                  ),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  locals.bacsVerifyBody,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: AppTheme.givtPurple,
                    builder: (BuildContext context) =>
                        const TermsAndConditionsDialog(
                      typeOfTerms: TypeOfTerms.directDebitGuarantee,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.givtBlue,
                  ),
                  child: Text(locals.bacsReadDdGuarantee),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () => registrationBloc.add(
                      RegistrationSignMandate(
                        appLanguage: locals.localeName,
                        guid: user.guid,
                      ),
                    ),
                    child: Text(locals.continueKey),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
