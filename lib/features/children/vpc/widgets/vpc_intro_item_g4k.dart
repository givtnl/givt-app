import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroItemG4K extends StatelessWidget {
  const VPCIntroItemG4K({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locals.vpcIntroG4KText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.sliderIndicatorFilled),
          ),
          Image.asset(
            'assets/images/vpc_intro_givt4kids.png',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () => context
                  .read<VPCCubit>()
                  .fetchURL(context.read<AuthCubit>().state.user.guid),
              child: Text(
                locals.enterCardDetailsButtonText,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
