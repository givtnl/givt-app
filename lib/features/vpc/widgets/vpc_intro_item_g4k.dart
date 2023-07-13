import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemG4K extends StatelessWidget {
  const VPCIntroItemG4K({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Make sure you download Givt4kids from the app store when you’ve set up your child profile(s).',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.sliderIndicatorFilled),
          ),
          Image.asset(
            'assets/images/vpc_intro_givt4kids.png',
          ),
          ElevatedButton(
            onPressed: () => context
                .read<VPCCubit>()
                .fetchURL(context.read<AuthCubit>().state.user.guid),
            child: Text(
              'Enter card details',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
