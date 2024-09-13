import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reflect/bloc/summary_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _cubit = SummaryCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: const FunTopAppBar(
        title: 'Awesome work heroes!',
        leading: GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, secretWord) {
          return Column(
            children: [
              const Spacer(),
              const TitleMediumText(
                'Your mission to connect through conversation was a success!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SvgPicture.asset('assets/family/images/family_superheroes.svg'),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: FunTile.gold(
                      titleBig: secretWord.minutesPlayed == 1
                          ? '1 minute family time'
                          : '${secretWord.minutesPlayed} minutes family time',
                      iconData: FontAwesomeIcons.solidClock,
                      assetSize: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FunTile.blue(
                      titleBig: '${secretWord.questionsAsked} questions asked',
                      iconData: FontAwesomeIcons.solidCircleQuestion,
                      assetSize: 32,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FunButton(
                onTap: () {
                  Navigator.of(context).popUntil(
                    ModalRoute.withName(
                      FamilyPages.profileSelection.name,
                    ),
                  );
                },
                text: 'Back to home',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.familyReflectSummaryBackToHome,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
