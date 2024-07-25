import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/notice_dialog.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class VPCPage extends StatelessWidget {
  const VPCPage({super.key, this.onReadyClicked});

  final void Function()? onReadyClicked;

  @override
  Widget build(BuildContext context) {
    final theme = FamilyAppTheme().toThemeData();
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              secureCardsIcon(width: 140, height: 140),
              Text(
                context.l10n.oneLastThing,
                style: theme.textTheme.titleLarge?.copyWith(),
              ),
              Text(
                "To set your family up and securely collect your child's information we want to make sure it’s an adult authorising this.\n\nWe'll collect \$0.50 from your card which you’ll see on your bank statement. ",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(flex: 2),
              TextButton(
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.directNoticeClicked,
                  );
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: AppTheme.givtPurple,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (context) => const NoticeDialog(),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.info_rounded,
                        color: FamilyAppTheme.primary20,
                        size: 18,
                      ),
                    ),
                    Text(
                      context.l10n.seeDirectNoticeButtonText,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                      ),
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
