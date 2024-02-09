import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/utils/cached_family_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CachedMembersDialogSuccessPage extends StatelessWidget {
  const CachedMembersDialogSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/donation_states_approved.svg',
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 30),
        Text(
          context.l10n.vpcNoFundsWoohoo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.givtBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.vpcNoFundsSuccess,
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
              CachedFamilyUtils.clearFamilyCache();
              context.pushReplacementNamed(Pages.childrenOverview.name);
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
      ],
    );
  }
}
