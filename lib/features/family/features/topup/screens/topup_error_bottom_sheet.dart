import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class TopupErrorBottomSheet extends StatelessWidget {
  const TopupErrorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      title: 'Oops, something went wrong',
      icon: errorCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.triangleExclamation,
        iconSize: 48,
      ),
      content: Column(
        children: [
          Text(
            'We are having trouble getting the funds from your card. Please try again.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: GivtElevatedButton(
        text: 'Ok',
        onTap: () {
          context.read<TopupCubit>().restart();
        },
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
