import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class ChildDetailsItem extends StatelessWidget {
  const ChildDetailsItem({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currency = NumberFormat.simpleCurrency(
      name: Util.getCurrencyName(
        country: Country.fromCode(user.country),
      ),
    );

    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.network(
              profile.pictureURL,
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profile.firstName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.inputFieldBorderSelected,
                ),
          ),
          Text(
            //TODO: POEditor
            '${currency.currencySymbol}${profile.wallet.balance.toStringAsFixed(0)} in Wallet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.inputFieldBorderSelected,
                ),
          ),
        ],
      ),
    );
  }
}
