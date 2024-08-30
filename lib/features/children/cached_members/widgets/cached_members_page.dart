import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_member_overview_widget.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CachedMembersPage extends StatelessWidget {
  const CachedMembersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<CachedMembersCubit>().state;
    var totalAllowance = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    state.members.forEach((member) => totalAllowance += member.allowance!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedMemberOverviewWidget(
          members: state.adults,
        ),
        const SizedBox(height: 20),
        CachedMemberOverviewWidget(
          members: state.children,
        ),
        const SizedBox(height: 32),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SvgPicture.asset('assets/images/error_info_icon.svg'),
              ),
              const SizedBox(width: 10),
              Expanded(child: getText(context, totalAllowance)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 24,
            right: 24,
            bottom: 12,
          ),
          //todo delete
          child: CustomGreenElevatedButton(
            onPressed: () => context
                .read<CachedMembersCubit>()
                .tryCreateMembersFromCache([]),
            title: context.l10n.tryAgain,
          ),
        ),
      ],
    );
  }

  Widget getText(BuildContext context, int allowance) {
    if (allowance < 0) {
      return Text.rich(
        TextSpan(
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppTheme.givtBlue,
                ),
          ),
          children: [
            TextSpan(text: context.l10n.vpcNoFundsInfo1),
            TextSpan(
              text: context.l10n.vpcNoFundsInfo2,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: context.l10n.vpcNoFundsInfo3),
            TextSpan(
              text: '\$$allowance',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(
              text:
                  " for your child's Wallet. Please check your payment details.",
            ),
          ],
        ),
      );
    }
    return Text.rich(
      TextSpan(
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppTheme.givtBlue,
              ),
        ),
        children: [
          TextSpan(text: context.l10n.vpcNoFundsInfo1),
          TextSpan(
            text: context.l10n.vpcNoFundsInfo2,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const TextSpan(
            text: ' for verification. Please check your payment details.',
          ),
        ],
      ),
    );
  }
}
