import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/pages/sign_bacs_mandate_page.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';

class BacsExplanationPage extends StatefulWidget {
  const BacsExplanationPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BacsExplanationPage(),
    );
  }

  @override
  State<BacsExplanationPage> createState() => _BacsExplanationPageState();
}

class _BacsExplanationPageState extends State<BacsExplanationPage> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Scaffold(
      appBar: RegistrationAppBar(
        title: Text(
          locals.bacsSetupTitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                builder: (context) => Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locals.bacsHelpTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          locals.bacsHelpBody,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))),
            icon: const Icon(
              Icons.question_mark_outlined,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              locals.bacsSetupBody,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 15,
                  ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            _buildAcceptPolicy(locals),
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                onPressed: _acceptedTerms
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => BlocProvider.value(
                              value: context.read<RegistrationBloc>(),
                              child: const SignBacsMandatePage(),
                            ),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(locals.continueKey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptPolicy(AppLocalizations locals) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        builder: (BuildContext context) => const TermsAndConditionsDialog(
          typeOfTerms: TypeOfTerms.bacsInfo,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value!;
              });
            },
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: locals.bacsUnderstoodNotice,
                  style: const TextStyle(fontSize: 13),
                ),
                const WidgetSpan(
                  child: Icon(Icons.info_rounded, size: 16),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
