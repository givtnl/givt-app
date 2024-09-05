import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/topup_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class EmptyWalletBottomSheet extends StatelessWidget {
  const EmptyWalletBottomSheet({super.key});

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
        amplitudeEvent: AmplitudeEvents.topupStartButtonClicked,
        onTap: () async {
          final user = context.read<ProfilesCubit>().state;
          context.read<TopupCubit>().init(user.activeProfile.id);
          await FamilyAuthUtils.authenticateUser(
            context,
            checkAuthRequest: CheckAuthRequest(
              navigate: (context, {isUSUser}) async {
                context.pop();

                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) => const TopupWalletBottomSheet(),
                );
              },
            ),
          );
        },
      ),
      secondaryButton: FunButton.secondary(
        text: 'Go back',
        leftIcon: FontAwesomeIcons.arrowLeft,
        onTap: () {
          context.pop();
        },
        amplitudeEvent: AmplitudeEvents.topupGoBackButtonClicked,
      ),
      closeAction: () {
        context.pop();
      },
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const EmptyWalletBottomSheet(),
    );
  }
}
