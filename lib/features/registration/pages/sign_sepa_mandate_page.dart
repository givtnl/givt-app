import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/registration_app_bar.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/utils/app_theme.dart';

class SignSepaMandatePage extends StatelessWidget {
  const SignSepaMandatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return Scaffold(
      appBar: const RegistrationAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: BlocListener<RegistrationBloc, RegistrationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RegistrationStatus.success) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            if (state.status == RegistrationStatus.conflict) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: locals.mandateFailed,
                  content: locals.mandateFailPersonalInformation,
                  onConfirm: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              );
            }

            if (state.status == RegistrationStatus.badRequest) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: locals.mandateFailed,
                  content: locals.duplicateAccountOrganisationMessage,
                  onConfirm: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              );
            }

            if (state.status == RegistrationStatus.failure) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: locals.mandateFailed,
                  content: locals.mandateFailTryAgainLater,
                  onConfirm: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              );
            }
          },
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                locals.bacsVerifyTitle,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInforRow(
                      value: '${user.firstName} ${user.lastName}',
                      icon: const Icon(Icons.person),
                      size: size,
                    ),
                    _buildInforRow(
                      value: user.email,
                      icon: const Icon(
                        Icons.alternate_email,
                        color: AppTheme.givtLightBlue,
                      ),
                      size: size,
                    ),
                    _buildInforRow(
                      value:
                          '${user.address} ${user.postalCode} ${user.city}, ${user.country}',
                      icon: const Icon(
                        FontAwesomeIcons.house,
                        color: AppTheme.givtLightGreen,
                      ),
                      size: size,
                    ),
                    _buildInforRow(
                      value: user.iban,
                      icon: const Icon(
                        FontAwesomeIcons.creditCard,
                        color: AppTheme.givtOrange,
                      ),
                      size: size,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                locals.sepaVerifyBody,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(locals.signMandateDisclaimer),
              ElevatedButton(
                onPressed: () => context.read<RegistrationBloc>().add(
                      RegistrationSignMandate(
                        guid: user.guid,
                        appLanguage: locals.localeName,
                      ),
                    ),
                child: Text(locals.signMandate),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInforRow({
    required String value,
    required Icon icon,
    required Size size,
  }) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.05,
        ),
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: icon,
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 15,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
