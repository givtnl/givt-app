import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/fun_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class TopupSuccessBottomSheet extends StatelessWidget {
  const TopupSuccessBottomSheet({
    required this.topupAmount,
    required this.recurring,
    super.key,
  });

  final int topupAmount;
  final bool recurring;

  @override
  Widget build(BuildContext context) {
    var text = "\$$topupAmount has been added to your child's Wallet";
    if (recurring) {
      text += ' and your recurring amount has been setup';
    }

    return GivtBottomSheet(
      title: 'Consider it done!',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          BodyMediumText(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: 'Done',
        amplitudeEvent: AmplitudeEvents.topupDoneButtonClicked,
        onTap: () {
          context.pop();
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
