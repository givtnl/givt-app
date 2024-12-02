import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    required this.header,
    required this.content,
    required this.button,
    required this.icon,
    required this.color,
    super.key,
  });

  final Widget header;
  final Widget content;
  final Widget button;
  final FunIcon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Container(
          height: 420,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.white,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      Container(
        height: 366,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: FamilyAppTheme.neutralVariant95,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(flex: 3),
              header,
              const Spacer(),
              const SizedBox(height: 4),
              content,
              const Spacer(),
              const SizedBox(height: 4),
              button,
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      Positioned(top: 0, child: icon),
      Positioned(
        top: icon.circleSize,
        child: const TitleMediumText('Read out loud'),
      ),
    ]);
  }
}
