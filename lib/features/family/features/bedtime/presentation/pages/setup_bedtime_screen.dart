import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/setup_bedtime_cubit.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime_arguments.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/widgets/bedtime_slider_widget.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_widget.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:go_router/go_router.dart';

class SetupBedtimeScreen extends StatefulWidget {
  const SetupBedtimeScreen({
    required this.arguments,
    super.key,
  });
  final BedtimeArguments arguments;

  @override
  State<SetupBedtimeScreen> createState() => _SetupBedtimeScreenState();
}

class _SetupBedtimeScreenState extends State<SetupBedtimeScreen> {
  final SetupBedtimeCubit _cubit = getIt<SetupBedtimeCubit>();
  late double bedtimeSliderValue;
  late int windDownValue;
  @override
  void initState() {
    super.initState();
    bedtimeSliderValue =
        widget.arguments.previousBedtime ?? BedtimeConfig().defaultBedtimeHour;
    windDownValue = widget.arguments.previousWinddownMinutes ??
        BedtimeConfig().defaultWindDownMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final child = widget.arguments.profiles[widget.arguments.index];
    return PopScope(
      canPop: false,
      child: BaseStateConsumer<dynamic, Bedtime>(
        cubit: _cubit,
        onCustom: (context, bedtime) {
          if (widget.arguments.index == widget.arguments.profiles.length - 1) {
            context.goNamed(FamilyPages.profileSelection.name);
            //todo navigate to mission screen
          } else {
            Navigator.of(context).push(
              SetupBedtimeScreen(
                arguments: BedtimeArguments(
                  bedtimeSliderValue,
                  windDownValue,
                  profiles: widget.arguments.profiles,
                  bedtimes: [bedtime, ...widget.arguments.bedtimes],
                  index: widget.arguments.index + 1,
                ),
              ).toRoute(context),
            );
          }
        },
        onInitial: (context) {
          return Material(
            child: ColoredBox(
              color: Colors.black,
              child: Stack(children: [
                //to do animate city before page navigation
                cityAtBottom(width, height),
                SafeArea(
                  child: Stack(
                    children: [
                      avatarEllipse(width, height, child),
                      content(child),
                    ],
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget avatarEllipse(double width, double height, Profile child) {
    return Stack(
      children: [
        Positioned(
          top: 24 + (144 / 2),
          left: (width / 2) - (144 / 2),
          child: ellipseArc(
            width: 144,
            height: 472,
          ),
        ),
        Positioned(
          top: 24,
          left: (width / 2) - (144 / 2),
          child: sunEllipse(width: 144, height: 144),
        ),
        Positioned(
          top: 24 + 22,
          left: (width / 2) - (80 / 2),
          child: AvatarWidget(
              uiModel: AvatarUIModel(
                avatarUrl: child.pictureURL,
                text: child.firstName,
              ),
              circleSize: 80,
              onTap: () {}),
        ),
      ],
    );
  }

  Widget cityAtBottom(double width, double height) {
    return Positioned(
      bottom: -height * 0.085,
      child: SizedBox(
        height: height * 0.3,
        width: width,
        child: SvgPicture.asset(
          'assets/family/images/city_purple.svg',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget content(Profile child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 160), // height of avatar sun ellipse
          const Spacer(),
          TitleMediumText(
            'What time does ${child.firstName} go to bed?',
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          const Spacer(),
          const SizedBox(height: 4),
          BedtimeSliderWidget(
            initialAmount: bedtimeSliderValue,
            onAmountChanged: (amount) {
              setState(() {
                bedtimeSliderValue = amount;
              });
            },
          ),
          const Spacer(flex: 3),
          const TitleMediumText(
            'How long do you usually take to wind down before bedtime?',
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          const Spacer(flex: 2),
          const SizedBox(height: 4),
          FunCounter(
            prefix: '',
            suffix: ' min',
            initialAmount: windDownValue,
            minAmount: BedtimeConfig().minWindDownMinutes,
            maxAmount: BedtimeConfig().maxWindDownMinutes,
            customIncrement: BedtimeConfig().windDownCounterSteps,
            textColor: Colors.white,
            onAmountChanged: (amount) {
              setState(() {
                windDownValue = amount;
              });
            },
          ),
          const Spacer(flex: 3),
          const BodySmallText(
            "We'll remind you to practice gratitude.",
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FunButton(
              onTap: () => _cubit.onClickContinue(
                  child.id, bedtimeSliderValue, windDownValue),
              text: 'Continue',
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.childBedtimeSet,
                parameters: {
                  'child': child.firstName,
                  'bedtime':
                      '${bedtimeSliderValue.floor().toInt().toString().padLeft(2, '0')}:${((bedtimeSliderValue - bedtimeSliderValue.floor()) * 60).toInt().toString().padLeft(2, '0')}',
                  'windDown': windDownValue,
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
