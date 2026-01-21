import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/pages/pages.dart';
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
          return const _SepaMandateExplanationPageView();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _SepaMandateExplanationPageView extends StatelessWidget {
  const _SepaMandateExplanationPageView();

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: locals.signMandateTitle,
        leading: const GivtBackButtonFlat(),
      ),
      floatingActionButton: FunButton(
        onTap: () => context.goNamed(
          Pages.signSepaMandate.name,
          extra: context.read<RegistrationBloc>(),
        ),
        text: locals.next,
        analyticsEvent: AmplitudeEvents.continueClicked.toEvent(),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (BuildContext context) => TermsAndConditionsDialog(
                content: locals.slimPayInfoDetail,
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: locals.slimPayInformation,
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.info_rounded, size: 16),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/givy_slim_pay.png',
            height: 160,
          ),
          const Spacer(),
          BodyMediumText(
            locals.slimPayInformationPart2,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
