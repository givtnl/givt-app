import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/setup_bedtime_cubit.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime_arguments.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/pages/mission_acceptance_screen.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/widgets/bedtime_slider_widget.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_widget.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
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
        widget.arguments.previousBedtime ?? BedtimeConfig.defaultBedtimeHour;
    windDownValue = widget.arguments.previousWinddownMinutes ??
        BedtimeConfig.defaultWindDownMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final child = widget.arguments.profiles[widget.arguments.index];
    final isLast =
        widget.arguments.index == widget.arguments.profiles.length - 1;
    return PopScope(
      canPop: widget.arguments.index != 0,
      child: BaseStateConsumer<dynamic, Bedtime>(
        cubit: _cubit,
        onError: (context, message) => ColoredBox(
          color: FamilyAppTheme.primary98,
          child: RetryErrorWidget(
            onTapPrimaryButton: () => _cubit.onClickContinue(
              child.id,
              bedtimeSliderValue,
              windDownValue,
            ),
            secondaryButtonText: 'Go Home',
            onTapSecondaryButton: () =>
                context.goNamed(FamilyPages.profileSelection.name),
            secondaryButtonAnalyticsEvent: AnalyticsEvent(
              AmplitudeEvents.returnToHomePressed,
            ),
          ),
        ),
        onLoading: (context) {
          return bedtimeSelectionScreen(width, height, child, true);
        },
        onCustom: (context, bedtime) {
          if (isLast) {
            Navigator.of(context)
                .push(const MissionAcceptanceScreen().toRoute(context));
          } else {
            Navigator.of(context).push(
              PageRouteBuilder<dynamic>(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SetupBedtimeScreen(
                  arguments: BedtimeArguments(
                    previousBedtime: bedtimeSliderValue,
                    previousWinddownMinutes: windDownValue,
                    profiles: widget.arguments.profiles,
                    bedtimes: [bedtime, ...widget.arguments.bedtimes],
                    index: widget.arguments.index + 1,
                  ),
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        onInitial: (context) {
          return bedtimeSelectionScreen(width, height, child, false);
        },
      ),
    );
  }

  FunScaffold bedtimeSelectionScreen(
      double width, double height, Profile child, bool isLoading) {
    return FunScaffold(
      withSafeArea: false,
      backgroundColor: FamilyAppTheme.secondary10,
      appBar: FunTopAppBar(
        systemNavigationBarColor: FamilyAppTheme.secondary10,
        color: FamilyAppTheme.secondary10,
        leading: widget.arguments.index == 0
            ? null
            : const GivtBackButtonFlat(
                color: Colors.white,
              ),
        title: null,
        titleColor: Colors.white,
      ),
      body: ColoredBox(
        color: FamilyAppTheme.secondary10,
        child: Stack(
          children: [
            cityAtBottom(width, height),
            Stack(
              children: [
                avatarEllipse(width, height, child),
                content(child, isLoading: isLoading),
              ],
            ),
          ],
        ),
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
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget cityAtBottom(double width, double height) {
    return Positioned(
      bottom: -height * 0.125,
      child: SizedBox(
        height: height * 0.25,
        width: width,
        child: SvgPicture.asset(
          'assets/family/images/city_purple.svg',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget content(Profile child, {bool isLoading = false}) {
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
            minAmount: BedtimeConfig.minWindDownMinutes,
            maxAmount: BedtimeConfig.maxWindDownMinutes,
            customIncrement: BedtimeConfig.windDownCounterSteps,
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
          FunButton(
            onTap: () => _cubit.onClickContinue(
              child.id,
              bedtimeSliderValue,
              windDownValue,
            ),
            isLoading: isLoading,
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
