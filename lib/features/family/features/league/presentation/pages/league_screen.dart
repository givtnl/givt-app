import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/league/bloc/league_cubit.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/empty_league.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_explanation.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_overview.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  final LeagueCubit _leagueCubit = getIt<LeagueCubit>();

  late DateTime mondayMidnight;
  Timer? _timer;
  late int _minutesUntilReset;
  late int daysDifference;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateDatesAndTimes();
    _leagueCubit.init();
    if (daysDifference <= 1) {
      _startCountdown();
    }
  }

  void _calculateDatesAndTimes() {
    final now = DateTime.now();
    mondayMidnight = DateTime(now.year, now.month, now.day).add(
      Duration(
        days: now.weekday == DateTime.monday
            ? 7
            : (DateTime.monday - now.weekday) % DateTime.daysPerWeek,
      ),
    );
    _minutesUntilReset = mondayMidnight.difference(now).inMinutes;
    daysDifference = mondayMidnight.difference(now).inDays;
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (_minutesUntilReset <= 0) {
        timer.cancel();
      } else {
        if (!mounted) return;
        setState(() {
          _minutesUntilReset--;
        });
      }
    });
  }

  int get _remainingMinutes {
    return _minutesUntilReset % 60;
  }

  int get _remainingHours {
    return _minutesUntilReset ~/ 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: const FunTopAppBar(
        title: 'League',
      ),
      body: BaseStateConsumer(
        cubit: _leagueCubit,
        onData: (context, uiModel) {
          switch (uiModel) {
            case final ShowLeagueOverview state:
              return LeagueOverview(
                uiModel: state.uiModel,
                dateLabel: _getDateLabel(),
              );
            case ShowLeagueExplanation():
              return LeagueExplanation(
                onContinuePressed: _leagueCubit.onExplanationContinuePressed,
              );
            case ShowEmptyLeague():
              return EmptyLeague(showGenerosityHunt: uiModel.showGenerosityHunt);
          }
        },
      ),
    );
  }

  String _getDateLabel() {
    return _remainingHours <= 24
        ? '${_remainingHours > 0 ? "${_remainingHours}h " : ""}${_remainingMinutes}m'
        : daysDifference == 1
            ? '1 day'
            : '$daysDifference days';
  }
}
