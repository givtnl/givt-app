import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reflect/bloc/result_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({required this.success, super.key});
  final bool success;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ResultCubit _cubit = ResultCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, secretWord) {
          return Stack(
            children: [
              if (widget.success)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Lottie.asset(
                      'assets/lotties/confetti.json',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              Column(
                children: [
                  const Spacer(),
                  Center(
                    child: widget.success
                        ? const FunIcon(
                            iconData: FontAwesomeIcons.check,
                            iconSize: 64,
                            circleColor: FamilyAppTheme.primary98,
                            circleSize: 192,
                          )
                        : const FunIcon(
                            iconData: FontAwesomeIcons.xmark,
                            iconSize: 64,
                            iconColor: FamilyAppTheme.error40,
                            circleColor: FamilyAppTheme.error90,
                            circleSize: 192,
                          ),
                  ),
                  BodyLargeText(
                    widget.success
                        ? 'Great job!'
                        : 'The right answer was:\n$secretWord!',
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Temporary solution
                  // Get users out of the flow from
                  FunButton(
                    onTap: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(
                          FamilyPages.profileSelection.name,
                        ),
                      );
                    },
                    text: 'Go back',
                    amplitudeEvent: AmplitudeEvents.reflectAndShareResultGoBackClicked,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
