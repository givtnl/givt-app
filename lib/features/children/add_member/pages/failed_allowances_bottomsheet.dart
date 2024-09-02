import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';

class InsufficientFundsBottomsheet extends StatelessWidget {
  InsufficientFundsBottomsheet({required this.amount, super.key});
  final int amount;
  final stripeCubit = getIt<StripeCubit>();

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      title: "You had inssufficient funds",
      icon: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: FamilyAppTheme.primary95,
            ),
          ),
          walletEmptyIcon(width: 140, height: 140),
        ],
      ),
      content: BodyMediumText(
        'We couldn’t take the \$${amount.toStringAsFixed(0)} to top up your child’s wallet.\n\nDon\'t worry we will try again tomorrow.',
        textAlign: TextAlign.center,
      ),
      secondaryButton: GivtElevatedSecondaryButton(
        text: 'Change payment method',
        rightIcon: const FaIcon(
          FontAwesomeIcons.arrowsRotate,
          size: 24,
        ),
        onTap: () async {
          if (!context.mounted) return;
          await stripeCubit.fetchSetupIntent();

          if (!context.mounted) return;

          try {
            await StripeHelper(context).showPaymentSheet();

            if (!context.mounted) return;
            await context.read<AuthCubit>().refreshUser();
          } on StripeException catch (e, stackTrace) {
            await AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.tryAgainForFailedVPCClicked,
            );

            /* Logged as info as stripe is giving exception
                               when for example people close the bottomsheet.
                               So it's not a real error :)
                            */
            LoggingInfo.instance.info(
              e.toString(),
              methodName: stackTrace.toString(),
            );
          }
        },
        amplitudeEvent: AmplitudeEvents.editPaymentDetailsCanceled,
      ),
    );
  }

  static void show(BuildContext context, int amount) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => InsufficientFundsBottomsheet(amount: amount),
    );
  }
}