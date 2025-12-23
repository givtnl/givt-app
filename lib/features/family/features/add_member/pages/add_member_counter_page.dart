import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/family/features/add_member/widgets/member_counter.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class AddMemberCounterPage extends StatefulWidget {
  const AddMemberCounterPage({
    this.initialAmount,
    this.showTopUp = false,
    this.existingFamily = false,
    super.key,
  });

  final int? initialAmount;
  final bool showTopUp;
  final bool existingFamily;

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
      canPop: widget.existingFamily,
      appBar: FunTopAppBar.primary99(
        title: context.l10n.setupFamilyTitle,
        leading: widget.existingFamily ? const GivtBackButtonFlat() : null,
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
                  existingFamily: widget.existingFamily,
                ).toRoute(context),
              );
            },
            text: context.l10n.buttonContinue,
            analyticsEvent: AnalyticsEventName.addMemberContinueClicked.toEvent(
              parameters: {'amount': _amount},
            ),
          ),
        ],
      ),
    );
  }
}
