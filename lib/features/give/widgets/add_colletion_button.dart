import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';

class AddCollectionButton extends StatelessWidget {
  const AddCollectionButton({
    required this.onPressed,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FunTheme.of(context).secondary80,
              width: 1,
            ),
          ),
          padding: EdgeInsets.zero,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const FaIcon(FontAwesomeIcons.plus),
            label: LabelMediumText(
              label,
              color: FunTheme.of(context).secondary30,
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: FunTheme.of(context).secondary30,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(50, 30),
            ),
          ),
        ),
      ),
    );
  }
}
