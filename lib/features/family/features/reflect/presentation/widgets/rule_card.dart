import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    required this.header,
    required this.content,
    required this.button,
    required this.icon,
    required this.color,
    required this.title,
    super.key,
  });

  final Widget header;
  final Widget content;
  final Widget button;
  final FunIcon icon;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              TitleMediumText(title),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: FamilyAppTheme.neutralVariant95,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      header,
                      const SizedBox(height: 16),
                      content,
                      const SizedBox(height: 16),
                      button,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(top: -48, child: icon),
      ],
    );
  }
}
