import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/helpers/logout_helper.dart';
import 'package:go_router/go_router.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: 'backButton',
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.arrowLeft,
        ),
        onPressed: () {
          context.canPop() ? context.pop() : logout(context);
        },
      ),
    );
  }
}
