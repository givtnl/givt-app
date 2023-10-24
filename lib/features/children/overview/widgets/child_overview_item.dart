import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildOverviewItem extends StatelessWidget {
  const ChildOverviewItem({
    required this.profile,
    super.key,
  });

  final Profile profile;
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currencySymbol = Util.getCurrencySymbol(countryCode: user.country);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: profile.monsterColorWithAlpha,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 2,
              color: profile.monsterColor,
            ),
          ),
          backgroundColor: profile.monsterColorWithAlpha,
        ),
        onPressed: () {
          context.pushNamed(
            Pages.childDetails.name,
            extra: [
              context.read<ChildrenOverviewCubit>(),
              profile,
            ],
          );
        },
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.network(
                  profile.pictureURL,
                  width: 70,
                  height: 70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.givtBlue,
                    ),
              ),
              Text(
                '$currencySymbol${profile.wallet.balance.toStringAsFixed(0)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.givtBlue,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
