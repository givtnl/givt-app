import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';

class CoinWidget extends StatelessWidget {
  const CoinWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<ProfilesCubit>().state.activeProfile;

    return Row(
      children: [
        Text(
          '\$${user.wallet.balance.round()}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(width: 8),
        SvgPicture.asset(
          'assets/family/images/coin_activated_small.svg',
          height: 44,
          width: 44,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
