// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class Wallet extends StatelessWidget {
  const Wallet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activeProfile = context.read<ProfilesCubit>().state.activeProfile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\$${activeProfile.wallet.balance.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: FamilyAppTheme.info20,
              ),
        ),
        SizedBox(width: 6),
        const Icon(
          FontAwesomeIcons.wallet,
          color: FamilyAppTheme.info40,
          size: 20,
        ),
      ],
    );
  }
}
