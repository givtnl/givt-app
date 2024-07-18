import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class ChildDetailsItem extends StatelessWidget {
  const ChildDetailsItem({
    required this.profileDetails,
    super.key,
  });

  final ProfileExt profileDetails;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currency = Util.getCurrency(countryCode: user.country);
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.network(
              profileDetails.profile.pictureURL,
              width: size.width * 0.20,
              height: size.width * 0.20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${currency.currencySymbol}${profileDetails.profile.wallet.balance.toStringAsFixed(0)}${context.l10n.childInWalletPostfix}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: AppTheme.primary30),
          ),
        ],
      ),
    );
  }
}
