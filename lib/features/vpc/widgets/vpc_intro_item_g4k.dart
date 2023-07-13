import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/vpc/cubit/vpc_cubit.dart';

class VPCIntroItemG4K extends StatelessWidget {
  const VPCIntroItemG4K({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Make sure you download Givt4kids from the app store when you’ve set up your child profile(s).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF184869),
            ),
          ),
          Image.asset(
            'assets/images/vpc_intro_givt4kids.png',
          ),
          ElevatedButton(
            onPressed: () => context
                .read<VPCCubit>()
                .fetchURL(context.read<AuthCubit>().state.user.guid),
            child: const Text(
              'Enter card details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
