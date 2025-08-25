import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:go_router/go_router.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FunButton(
      text: 'Back to home',
      leftIcon: FontAwesomeIcons.house,
      onTap: () async {
        context.goNamed(FamilyPages.wallet.name);
        context.read<FlowsCubit>().resetFlow();
      },
      analyticsEvent: AmplitudeEvents.returnToHomePressed.toEvent(),
    );
  }
}
