import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class TopupSuccessBottomSheet extends StatelessWidget {
  const TopupSuccessBottomSheet({required this.topupAmount, super.key});

  final int topupAmount;

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      title: 'Consider it done!',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          Text(
            "\$$topupAmount has been added to your child's Wallet",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: GivtElevatedButton(
        text: 'Done',
        onTap: () {
          context.read<ProfilesCubit>().fetchActiveProfile();
          context.pop();
        },
      ),
      closeAction: () {
        context.read<ProfilesCubit>().fetchActiveProfile();
        context.pop();
      },
    );
  }
}
