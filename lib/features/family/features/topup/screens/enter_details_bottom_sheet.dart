import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/registration/pages/credit_card_details.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class EnterDetailsBottomSheet extends StatelessWidget {
  const EnterDetailsBottomSheet({required this.onSuccess, super.key});
  final VoidCallback onSuccess;
  @override
  Widget build(BuildContext context) {
    final name =
        context.read<ProfilesCubit>().state.activeProfile.possessiveName;
    return FunBottomSheet(
      title: 'Top up $name empty Wallet',
      icon: walletEmptyIcon(),
      content: const BodyMediumText(
        "To top up your child's account we need your payment details ",
        textAlign: TextAlign.center,
      ),
      primaryButton: FunButton(
          text: 'Enter payment details',
          analyticsEvent:
              AnalyticsEvent(AmplitudeEvents.enterCardDetailsClicked),
          onTap: () {
            CreditCardDetails.show(
              context,
              onSuccess: () {
                Navigator.of(context).pop();
                TopupWalletBottomSheet.show(context, onSuccess);
              },
            );
          }),
      closeAction: () {
        Navigator.of(context).pop();
      },
    );
  }

  static void show(BuildContext context, VoidCallback onSuccess) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => EnterDetailsBottomSheet(
        onSuccess: onSuccess,
      ),
    );
  }
}
