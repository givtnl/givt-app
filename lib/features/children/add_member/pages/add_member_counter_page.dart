import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/children/add_member/widgets/smiley_counter.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class AddMemberCounterPage extends StatefulWidget {
  const AddMemberCounterPage({this.initialAmount, super.key});
  final int? initialAmount;
  @override
  State<AddMemberCounterPage> createState() => _AddMemberCounterPageState();
}

class _AddMemberCounterPageState extends State<AddMemberCounterPage> {
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = 1;
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Set up Family',
        leading: const GenerosityBackButton(),
      ),
      body: Column(
        children: [
          const BodyMediumText(
            'How many family members (besides you) do you want to add?',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SmileyCounter(totalCount: _amount),
          const SizedBox(height: 24),
          FunCounter(
            currency: '',
            initialAmount: _amount,
            onAmountChanged: (amount) => setState(() {
              _amount = amount;
            }),
            maxAmount: 6,
          ),
          const SizedBox(height: 40),
          const Spacer(),
          FunButton(
            onTap: () async {
              await Navigator.push(
                context,
                FamilyMemberFormPage(
                  index: 1,
                  totalCount: _amount,
                  membersToCombine: const [],
                ).toRoute(context),
              );
            },
            text: 'Continue',
            rightIcon: FontAwesomeIcons.arrowRight,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.addMemberContinueClicked,
              parameters: {'amount': _amount},
            ),
          ),
        ],
      ),
    );
  }
}
