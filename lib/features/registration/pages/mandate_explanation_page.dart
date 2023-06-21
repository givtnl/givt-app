import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/pages/bacs_explanation_page.dart';
import 'package:givt_app/features/registration/pages/sign_sepa_mandate_page.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';

class MandateExplanationPage extends StatelessWidget {
  const MandateExplanationPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => RegistrationBloc(
          authCubit: context.read<AuthCubit>(),
          authRepositoy: getIt(),
        )..add(const RegistrationInit()),
        child: const MandateExplanationPage(),
      ),
    );
  }

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const RegistrationAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                builder: (BuildContext context) =>
                    const TermsAndConditionsDialog(
                  typeOfTerms: TypeOfTerms.slimPayInfo,
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: locals.slimPayInformation,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const WidgetSpan(
                      child: Icon(Icons.info_rounded, size: 16),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/givy_slim_pay.png',
              height: size.height * 0.2,
            ),
            const Spacer(),
            Text(
              locals.slimPayInformationPart2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<RegistrationBloc>(),
                    child: const SignSepaMandatePage(),
                  ),
                ),
              ),
              child: Text(locals.next),
            )
          ],
        ),
      ),
    );
  }
}
