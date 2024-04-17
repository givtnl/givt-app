import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/day_button.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityChallengeOverview extends StatelessWidget {
  const GenerosityChallengeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.watch<GenerosityChallengeCubit>();
    final auth = context.watch<AuthCubit>().state;
    final arePersonalDetailsAvailable =
        auth.status == AuthStatus.authenticated &&
            auth.user.personalInfoRegistered;
    return Scaffold(
      appBar: const GenerosityAppBar(
        title: 'Generosity Mission',
        leading: null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (arePersonalDetailsAvailable)
              SvgPicture.asset(
                'assets/images/generosity_challenge_backdrop.svg',
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fitWidth,
              ),
            Column(
              children: [
                if (arePersonalDetailsAvailable)
                  _buildGenerosityHeader(auth.user.lastName),
                GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: GenerosityChallengeHelper.generosityChallengeDays,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final day = challenge.state.days[index];
                    return DayButton(
                      isCompleted: day.isCompleted,
                      isActive: challenge.state.activeDayIndex == index,
                      dayIndex: index,
                      onPressed: day.isCompleted ||
                              challenge.state.activeDayIndex == index
                          ? () {
                              AnalyticsHelper.logEvent(
                                eventName: AmplitudeEvents
                                    .generosityChallengeDayClicked,
                                eventProperties: {
                                  'day': index + 1,
                                },
                              );
                              challenge.dayDetails(index);
                            }
                          : () {},
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerosityHeader(String name) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          SvgPicture.asset(
            'assets/images/family_avatar.svg',
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 14),
          Text(
            'The $name Family',
            style: const TextStyle(
              color: AppTheme.primary20,
              fontSize: 18,
              fontFamily: 'Rouna',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}
