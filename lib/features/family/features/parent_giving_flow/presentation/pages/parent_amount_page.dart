import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class ParentAmountPage extends StatefulWidget {
  const ParentAmountPage({
    required this.currency,
    required this.organisationName,
    required this.colorCombo,
    required this.icon,
    super.key,
  });

  final String currency;
  final String organisationName;
  final ColorCombo colorCombo;
  final IconData icon;

  @override
  State<ParentAmountPage> createState() => _ParentAmountPageState();
}

class _ParentAmountPageState extends State<ParentAmountPage> {
  final initialamount = 5;
  late int _amount;
  @override
  void initState() {
    super.initState();
    _amount = initialamount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Give',
        leading: const GenerosityBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                primaryCircleWithIcon(
                  circleSize: MediaQuery.of(context).size.width * 0.3,
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                  iconData: widget.icon,
                  circleColor: widget.colorCombo.backgroundColor,
                  iconColor: widget.colorCombo.textColor.withOpacity(0.6),
                ),
                const SizedBox(height: 16),
                TitleLargeText(
                  widget.organisationName,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const BodyMediumText(
                  'How much would you like to give?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FunCounter(
                  currency: widget.currency,
                  initialAmount: initialamount,
                  onAmountChanged: (amount) => setState(() {
                    _amount = amount;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FunButton(
        onTap: () {
          Navigator.of(context).pop(_amount);
        },
        text: 'Give',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.parentGiveClicked,
        ),
      ),
    );
  }
}
