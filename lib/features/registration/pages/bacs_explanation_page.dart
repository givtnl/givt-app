import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class BacsExplanationPage extends StatefulWidget {
  const BacsExplanationPage({
    super.key,
  });

  @override
  State<BacsExplanationPage> createState() => _BacsExplanationPageState();
}

class _BacsExplanationPageState extends State<BacsExplanationPage> {
  bool _acceptedTerms = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.signMandateTitle,
        actions: [
          IconButton(
            onPressed: () => FunBottomSheet(
              title: locals.bacsHelpTitle,
              content: BodyMediumText(
                locals.bacsHelpBody,
                textAlign: TextAlign.center,
              ),
              closeAction: () => context.pop(),
            ).show(context),
            icon: const Icon(
              Icons.question_mark_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FunButton(
        onTap: _acceptedTerms
            ? () => context.goNamed(
                Pages.signBacsMandate.name,
                extra: context.read<RegistrationBloc>(),
              )
            : null,
        onDisabledTap: () {
          // Scroll to bottom when disabled to show checkbox
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        isDisabled: !_acceptedTerms,
        text: locals.buttonContinue,
        analyticsEvent: AmplitudeEvents.continueClicked.toEvent(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMediumText(locals.bacsSetupTitle, textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            BodyMediumText(
              textAlign: TextAlign.center,
              locals.bacsSetupBody,
            ),
            const SizedBox(height: 40),
            _buildAcceptPolicy(locals),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptPolicy(AppLocalizations locals) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (BuildContext context) => TermsAndConditionsDialog(
          content: locals.bacsAdvanceNotice,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            semanticLabel: 'bacsCheckbox',
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value!;
              });
            },
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: locals.bacsUnderstoodNotice,
                    style: const FamilyAppTheme()
                        .toThemeData()
                        .textTheme
                        .bodySmall,
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.info_rounded,
                        size: 16,
                        color: FamilyAppTheme.primary40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
