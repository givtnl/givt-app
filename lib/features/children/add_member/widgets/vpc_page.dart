import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/notice_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class VPCPage extends StatelessWidget {
  const VPCPage({super.key, this.onReadyClicked});

  final void Function()? onReadyClicked;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              secureCardsIcon(width: 140, height: 140),
              TitleMediumText(
                context.l10n.oneLastThing,
              ),
              const BodyMediumText(
                "To set your family up and securely collect your child's information we want to make sure it’s an adult authorising this.\n\nWe'll collect \$0.50 from your card which you’ll see on your bank statement. ",
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              TextButton(
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.directNoticeClicked,
                  );
                  showModalBottomSheet<void>(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (context) => const NoticeDialog(),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.circleInfo,
                      color: FamilyAppTheme.primary20,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    BodySmallText.primary40(
                      context.l10n.seeDirectNoticeButtonText,
                    ),
                  ],
                ),
              ),
              GivtElevatedButton(
                onTap: onReadyClicked ??
                    () {
                      context.pop();
                      context.read<AddMemberCubit>().createMember();
                    },
                text: context.l10n.ready,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
