import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/cubit/offline_queue_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/utils.dart';

class OfflineGivingBanner extends StatelessWidget {
  const OfflineGivingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineQueueCubit, OfflineQueueState>(
      builder: (context, state) {
        if (!state.shouldShowBanner) {
          return const SizedBox.shrink();
        }

        final theme = FunTheme.of(context);
        final locals = context.l10n;
        final country = Country.fromCode(context.read<AuthCubit>().state.user.country);
        final currencySymbol = Util.getCurrencySymbol(countryCode: country.countryCode);
        final formattedAmount =
            '$currencySymbol${Util.formatNumberComma(state.totalAmount, country)}';

        final String? title;
        final String body;

        final isOffline = state.isOffline;

        if (state.pendingCount == 0) {
          title = null;
          body = locals.offlineBannerNoPending;
        } else if (state.pendingCount == 1) {
          title = locals.offlineBannerPendingTitleSingular;
          body = isOffline
              ? locals.offlineBannerPendingBodySingular(formattedAmount)
              : locals.offlineBannerPendingOnlineBodySingular(formattedAmount);
        } else {
          title = locals.offlineBannerPendingTitlePlural(state.pendingCount);
          body = isOffline
              ? locals.offlineBannerPendingBodyPlural(formattedAmount)
              : locals.offlineBannerPendingOnlineBodyPlural(formattedAmount);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.highlight95,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isOffline ? Icons.wifi_off : Icons.sync,
                  size: 20,
                  color: theme.highlight50,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        TitleMediumText(
                          title,
                          color: theme.highlight30,
                        ),
                        const SizedBox(height: 2),
                      ],
                      BodyMediumText(
                        body,
                        color: theme.highlight30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
