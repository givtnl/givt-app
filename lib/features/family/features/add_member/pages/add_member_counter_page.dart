import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/family/features/add_member/widgets/member_counter.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class AddMemberCounterPage extends StatefulWidget {
  const AddMemberCounterPage(
      {this.initialAmount,
      this.showTopUp = false,
      this.canPop = false,
      super.key});
  final int? initialAmount;
  final bool showTopUp;
  final bool canPop;
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
      canPop: widget.canPop,
      appBar: FunTopAppBar.primary99(
        title: 'Set up Family',
        leading: widget.canPop ? const GivtBackButtonFlat() : null,
      ),
      body: Column(
        children: [
          const BodyMediumText(
            'How many family members do you want to add?',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          MemberCounter(totalCount: _amount, displayFamily: false),
          const SizedBox(height: 24),
          FunCounter(
            prefix: '',
            initialAmount: _amount,
            onAmountChanged: (amount) => setState(() {
              _amount = amount;
            }),
            maxAmount: 6,
          ),
          const SizedBox(height: 40),
          const Spacer(),
          FunButton(
            isDisabled: _amount < 1,
            onTap: () async {
              await Navigator.push(
                context,
                FamilyMemberFormPage(
                  index: 1,
                  totalCount: _amount,
                  membersToCombine: const [],
                  showTopUp: widget.showTopUp,
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
