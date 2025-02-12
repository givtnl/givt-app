import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/my_givts_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/color_combo.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({required this.profile, super.key});

  final Profile profile;

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final activeProfile = state.activeProfile == Profile.empty()
            ? widget.profile
            : state.activeProfile;
        return Scaffold(
          appBar: _topAppBar(activeProfile, context),
          backgroundColor: FamilyAppTheme.secondary99,
          body: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                _parentHeaderWidget(activeProfile, context),
                _giveTile(context),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onEditAvatarClicked(BuildContext context) {
    context.pushNamed(FamilyPages.parentAvatarSelection.name);
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.editAvatarPictureClicked,
    );
  }

  void _onProfileSwitchPressed(BuildContext context) {
    context.pop();
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.profileSwitchPressed,
    );
  }

  Widget _giveTile(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: FunTile(
          onTap: () => context.pushNamed(FamilyPages.giveByListFamily.name),
          borderColor: ColorCombo.secondary.borderColor,
          backgroundColor: ColorCombo.secondary.backgroundColor,
          textColor: ColorCombo.secondary.textColor,
          iconPath: 'assets/family/images/give_tile.svg',
          titleBig: 'Give',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.parentGiveTileClicked,
          ),
        ),
      );

  FunTopAppBar _topAppBar(Profile profile, BuildContext context) =>
      FunTopAppBar(
        title: profile.firstName,
        color: FamilyAppTheme.secondary99,
        systemNavigationBarColor: FamilyAppTheme.secondary99,
        leading: const GivtBackButtonFlat(),
      );

  Widget _parentHeaderWidget(Profile profile, BuildContext context) =>
      Container(
        width: MediaQuery.sizeOf(context).width,
        color: FamilyAppTheme.secondary99,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              width: MediaQuery.sizeOf(context).width,
              child: SvgPicture.asset(
                'assets/family/images/parent_home_background.svg',
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: () => _onEditAvatarClicked(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.network(
                      profile.pictureURL,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyGivtsButton(userId: profile.id),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      );
}
