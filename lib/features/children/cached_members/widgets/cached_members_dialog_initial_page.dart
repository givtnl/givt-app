import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CachedMembersDialogInitialPage extends StatelessWidget {
  const CachedMembersDialogInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        SvgPicture.asset(
          'assets/images/wallet.svg',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 20),
        Text(
          //TODO: POEditor
          'Almost done...',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          //TODO: POEditor
          "We couldn't take the funds from your bank account. Please check your balance and try again.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.givtBlue,
              ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              context.pop();
              context.read<CachedMembersCubit>().overviewCached();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              context.l10n.continueKey,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.childHistoryApproved,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
