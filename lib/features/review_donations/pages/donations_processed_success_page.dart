import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class DonationsProcessedSuccessPage extends StatelessWidget {
  const DonationsProcessedSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final countryObj = Country.fromCode(user.country);

    // Get parameters from route
    final routeState = GoRouterState.of(context);
    final routeData = routeState.uri.queryParameters;
    final amount = double.tryParse(routeData['amount'] ?? '0') ?? 0.0;
    final businessDays = int.tryParse(routeData['businessDays'] ?? '3') ?? 3;

    // Format amount
    final currencySymbol = Util.getCurrencySymbol(countryCode: user.country);
    final formattedAmount = Util.formatNumberComma(amount, countryObj);
    final formattedAmountString = '$currencySymbol $formattedAmount';

    // Format description with variables (l10n function takes parameters)
    final description = locals.reviewDonationsProcessedDescription(
      formattedAmountString,
      businessDays.toString(),
    );

    return FunScaffold(
      canPop: false,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Celebration illustration
                SvgPicture.asset(
                  'assets/images/givy_celebration.svg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 25),
                TitleMediumText(
                  locals.reviewDonationsProcessedTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                BodyMediumText(
                  description,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Button at the bottom
          FunButton(
            onTap: () => _handleDone(context, user.country),
            text: locals.buttonDone,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.continueClicked,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDone(BuildContext context, String countryCode) {
    // Navigate based on country
    if (Country.unitedKingdomCodes().contains(countryCode)) {
      // UK users go to Gift Aid
      context.goNamed(Pages.giftAid.name);
    } else {
      // EU users go to Biometric permission
      context.pushNamed(
        Pages.permitBiometric.name,
        extra: PermitBiometricRequest.registration(
          redirect: (context) =>
              context.goNamed(Pages.registrationSuccess.name),
        ),
      );
    }
  }
}
