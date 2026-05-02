import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class MandateExplanationPage extends StatelessWidget {
  const MandateExplanationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state.status ==
            RegistrationStatus.bacsDirectDebitMandateExplanation) {
          return const BacsExplanationPage();
        }
        if (state.status == RegistrationStatus.sepaMandateExplanation) {
          return const _SepaMandateIntroPage();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/// EU/SEPA — [Figma](https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49287-189570&m=dev)
class _SepaMandateIntroPage extends StatelessWidget {
  const _SepaMandateIntroPage();

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return _MandateSetupIntroScaffold(
      title: locals.mandateIntroTitleSepa,
      body: locals.mandateIntroBodySepa,
      onContinue: () => context.goNamed(
        Pages.signSepaMandate.name,
        extra: context.read<RegistrationBloc>(),
      ),
    );
  }
}

/// UK Direct Debit — [Figma](https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49287-189463&m=dev)
class BacsExplanationPage extends StatelessWidget {
  const BacsExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return _MandateSetupIntroScaffold(
      title: locals.mandateIntroTitleUk,
      body: locals.mandateIntroBodyUk,
      onContinue: () => context.goNamed(
        Pages.signBacsMandate.name,
        extra: context.read<RegistrationBloc>(),
      ),
    );
  }
}

class _MandateSetupIntroScaffold extends StatelessWidget {
  const _MandateSetupIntroScaffold({
    required this.title,
    required this.body,
    required this.onContinue,
  });

  final String title;
  final String body;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FunIconGivy.phone(),
                        const SizedBox(height: 24),
                        TitleMediumText(
                          title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: BodyMediumText(
                            body,
                            textAlign: TextAlign.center,
                            color: FunTheme.of(context).primary20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          FunButton(
            onTap: onContinue,
            text: context.l10n.buttonContinue,
            analyticsEvent: AnalyticsEventName.continueClicked.toEvent(),
          ),
        ],
      ),
    );
  }
}
