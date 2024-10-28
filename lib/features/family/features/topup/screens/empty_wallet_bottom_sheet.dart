import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/enter_details_bottom_sheet.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class EmptyWalletBottomSheet extends StatelessWidget {
  const EmptyWalletBottomSheet(
      {required this.afterSuccessAction,
      this.awaitActiveProfileBalance = false,
      super.key});
  final VoidCallback afterSuccessAction;
  final bool awaitActiveProfileBalance;
  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      title: 'Oops, an empty Wallet',
      icon: walletEmptyIcon(),
      content: const BodyMediumText(
        "To continue giving you need to add more money to your Wallet. You'll need your parent to do this.",
        textAlign: TextAlign.center,
      ),
      primaryButton: FunButton(
        text: 'Top up',
        leftIcon: FontAwesomeIcons.plus,
        analyticsEvent: AnalyticsEvent(AmplitudeEvents.topupStartButtonClicked),
        onTap: () async {
          final user = context.read<ProfilesCubit>().state;
          context.read<TopupCubit>().init(user.activeProfile.id);
          await FamilyAuthUtils.authenticateUser(
            context,
            checkAuthRequest: FamilyCheckAuthRequest(navigate: (context) async {
              context.pop();
              final isMissingCardDetails =
                  context.read<AuthCubit>().state.user.isMissingcardDetails;
              if (isMissingCardDetails) {
                EnterDetailsBottomSheet.show(
                  context,
                  afterSuccessAction,
                  awaitActiveProfileBalance,
                );
                return;
              }
              TopupWalletBottomSheet.show(
                context,
                afterSuccessAction,
                awaitActiveProfileBalance,
              );
            }),
          );
        },
      ),
      secondaryButton: FunButton.secondary(
        text: 'Go back',
        leftIcon: FontAwesomeIcons.arrowLeft,
        onTap: () {
          context.pop();
        },
        analyticsEvent:
            AnalyticsEvent(AmplitudeEvents.topupGoBackButtonClicked),
      ),
      closeAction: () {
        context.pop();
      },
    );
  }

  static void show(BuildContext context, VoidCallback afterSuccessAction,
      {bool? awaitActiveProfileBalance}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => EmptyWalletBottomSheet(
        afterSuccessAction: afterSuccessAction,
        awaitActiveProfileBalance: awaitActiveProfileBalance ?? false,
      ),
    );
  }
}
