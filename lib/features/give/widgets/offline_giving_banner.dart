import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/cubit/offline_queue_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/components/overlays/fun_snackbar.dart';
import 'package:givt_app/shared/design_system/theme/fun_theme_legacy.dart';
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
          child: FunSnackbarWidget(
            title: title,
            extraText: body,
            icon: Icon(
              isOffline ? Icons.wifi_off : Icons.sync,
              size: 24,
              color: FamilyAppTheme.highlight50,
            ),
            variant: FunSnackbarVariant.alert,
          ),
        );
      },
    );
  }
}
