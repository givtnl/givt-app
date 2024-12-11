import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime_arguments.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/pages/intro_bedtime_screen.dart';
import 'package:givt_app/features/family/features/reflect/bloc/leave_game_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/grateful_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_dialog.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class LeaveGameButton extends StatefulWidget {
  const LeaveGameButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  State<LeaveGameButton> createState() => _LeaveGameButtonState();
}

class _LeaveGameButtonState extends State<LeaveGameButton> {
  final _cubit = getIt<LeaveGameCubit>();

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: (context, custom) {
        if (!custom.isFirstRound && custom.kidsWithoutBedtimeSetup.isNotEmpty) {
          Navigator.of(context).push(
            IntroBedtimeScreen(
              arguments: BedtimeArguments(
                BedtimeConfig.defaultBedtimeHour,
                BedtimeConfig.defaultWindDownMinutes,
                profiles: custom.kidsWithoutBedtimeSetup,
                bedtimes: const [],
                index: 0,
              ),
            ).toRoute(context),
          );
        } else if (custom.isFirstRound && custom.hasAtLeastStartedInterview) {
          Navigator.of(context).push(const SummaryScreen().toRoute(context));
        } else if (!custom.isFirstRound && custom.hasAtLeastStartedInterview) {
          Navigator.of(context).push(const GratefulScreen().toRoute(context));
        } else {
          context.goNamed(
            FamilyPages.profileSelection.name,
          );
        }
      },
      onInitial: (context) {
        return IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: widget.onPressed ??
              () {
                LeaveGameDialog(
                  onConfirmLeaveGame: _cubit.onConfirmLeaveGameClicked,
                ).show(context);
                unawaited(
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.reflectAndShareLeaveGameButtonClicked,
                  ),
                );
              },
        );
      },
    );
  }
}
