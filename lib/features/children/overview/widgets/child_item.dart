import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChildItem extends StatelessWidget {
  const ChildItem({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currencySymbol = Util.getCurrencySymbol(countryCode: user.country);

    return InkWell(
      onTap: () => context.pushNamed(
        Pages.childDetails.name,
        extra: profile,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.childItemBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          width: double.infinity,
          height: profile.wallet.pending != 0 ? 100 : 75,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 5,
                    left: 20,
                    right: 20,
                    bottom: profile.wallet.pending != 0 ? 0 : 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          profile.firstName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              context.l10n.childOverviewTotalAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              '$currencySymbol ${profile.wallet.total.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (profile.wallet.pending != 0)
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.childItemPendingBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  width: double.infinity,
                  height: 25,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.childOverviewPendingApproval,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$currencySymbol ${profile.wallet.pending.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
