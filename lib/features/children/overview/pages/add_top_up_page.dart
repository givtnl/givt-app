import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class AddTopUpPage extends StatefulWidget {
  const AddTopUpPage({
    required this.currency,
    this.initialAmount,
    super.key,
  });

  final String currency;
  final int? initialAmount;

  @override
  State<AddTopUpPage> createState() => _AddTopUpPageState();
}

class _AddTopUpPageState extends State<AddTopUpPage> {
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Top Up',
        leading: GivtBackButtonFlat(),
      ),
      body: Center(
        child: Stack(
          children: [
            Align(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    primaryCircleWithIcon(
                      iconData: FontAwesomeIcons.plus,
                      circleSize: 140 - 28,
                      iconSize: 48,
                    ),
                    const SizedBox(height: 16),
                    FunCounter(
                      prefix: widget.currency,
                      initialAmount: _amount,
                      onAmountChanged: (amount) => setState(() {
                        _amount = amount;
                      }),
                    ),
                    const SizedBox(height: 12),
                    BodyMediumText(
                      context.l10n.topUpScreenInfo,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdminFeeText(
                    amount: _amount.toDouble(),
                  ),
                  const SizedBox(height: 4),
                  FunButton(
                    text: context.l10n.confirm,
                    onTap: () {
                      Navigator.of(context).pop(_amount);
                    },
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.topUpConfirmClicked,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
