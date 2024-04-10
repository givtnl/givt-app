import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_challenge_daily_card.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityChallengeActiveDay extends StatelessWidget {
  const GenerosityChallengeActiveDay({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<GenerosityChallengeCubit>();
    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Day ${challenge.state.activeDayIndex + 1}',
        leading: BackButton(
          onPressed: challenge.overview,
          color: AppTheme.givtGreen40,
        ),
      ),
      body: const SafeArea(child: GenerosityDailyCard()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GivtElevatedButton(
        onTap: challenge.completeActiveDay,
        text: 'Complete',
        leftIcon: FontAwesomeIcons.solidSquareCheck,
      ),
    );
  }
}
