import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/children/add_member/widgets/smiley_counter.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/analytics_helper.dart';

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
    return Scaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Set up Family',
        leading: const GenerosityBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const BodyMediumText(
                  'How many family members (besides you) do you want to add?',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SmileyCounter(totalCount: _amount),
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
                    unawaited(
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.numberOfMembersSelected,
                        eventProperties: {
                          'nrOfMembers': _amount,
                        },
                      ),
                    );
                    await Navigator.push(
                      context,
                      FamilyMemberFormPage(
                        index: 1,
                        totalCount: _amount,
                        membersToCombine: [],
                      ).toRoute(context),
                    );
                  },
                  text: 'Continue',
                  rightIcon: FontAwesomeIcons.arrowRight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
