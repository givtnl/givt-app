import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/family/features/add_member/widgets/member_counter.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class AddFamilyCounterPage extends StatefulWidget {
  const AddFamilyCounterPage({required this.existingFamily, super.key});

  final bool existingFamily;

  @override
  State<AddFamilyCounterPage> createState() => _AddFamilyCounterPageState();
}

class _AddFamilyCounterPageState extends State<AddFamilyCounterPage> {
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = 2;
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        title: context.l10n.setupFamilyTitle,
      ),
      body: Column(
        children: [
          TitleMediumText(
            context.l10n.setupFamilyHowManyTitle,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          MemberCounter(totalCount: _amount - 1),
          const SizedBox(height: 24),
          FunCounter(
            prefix: '',
            initialAmount: _amount,
            onAmountChanged: (amount) => setState(() {
              _amount = amount;
            }),
            maxAmount: 6,
            minAmount: 2,
          ),
          const SizedBox(height: 40),
          const Spacer(),
          FunButton(
            isDisabled: _amount < 2,
            onTap: () async {
              await Navigator.push(
                context,
                FamilyMemberFormPage(
                  index: 1,
                  totalCount: _amount -
                      1, // -1 because the first member is already added
                  membersToCombine: const [],
                  existingFamily: widget.existingFamily,
                ).toRoute(context),
              );
            },
            text: context.l10n.buttonContinue,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.addMemberContinueClicked,
              parameters: {'nrOfAddedMembers': _amount - 1},
            ),
          ),
        ],
      ),
    );
  }
}
