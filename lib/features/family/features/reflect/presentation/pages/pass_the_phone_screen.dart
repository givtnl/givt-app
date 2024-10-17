import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gratitude_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/rule_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/reporters_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class PassThePhone extends StatelessWidget {
  const PassThePhone({
    required this.user,
    required this.onTap,
    this.customHeader,
    super.key, this.customBtnText,
  });

  factory PassThePhone.toSuperhero(GameProfile superhero) {
    return PassThePhone(
      user: superhero,
      onTap: (context) => Navigator.of(context).pushReplacement(
        RuleScreen.toSuperhero(superhero).toRoute(context),
      ),
    );
  }

  factory PassThePhone.toSidekick(GameProfile sidekick,
      {bool toRules = false}) {
    return PassThePhone(
      user: sidekick,
      onTap: (context) => Navigator.of(context).pushReplacement(
        toRules
            ? RuleScreen.toSidekick(sidekick).toRoute(context)
            : const GratitudeSelectionScreen().toRoute(context),
      ),
    );
  }

  factory PassThePhone.toReporters(List<GameProfile> reporters) {
    return PassThePhone(
      user: reporters.first,
      customHeader: ReportersWidget(
        reporters: reporters,
        circleSize: 120,
        displayName: false,
      ),
      onTap: (context) => Navigator.of(context).pushReplacement(
        RuleScreen.toReporters(reporters).toRoute(context),
      ),
    );
  }

  final String? customBtnText;
  final Widget? customHeader;

  final GameProfile user;
  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: user.role!.color.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SvgPicture.asset(
                  'assets/family/images/pass-the-phone.svg',
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: customHeader ??
                        GameProfileItem(
                          profile: user,
                          size: 120,
                          displayName: false,
                          displayRole: false,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TitleMediumText(
                    user.roles.length > 1
                        ? 'Pass the phone to the\n ${user.roles.first.name} and ${user.roles.last.name} ${user.firstName}'
                        : 'Pass the phone to the\n ${user.role!.name} ${user.firstName}',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FunButton.secondary(
                      onTap: () => onTap.call(context),
                      text: customBtnText ?? 'Continue',
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.reflectAndSharePassThePhoneClicked,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
