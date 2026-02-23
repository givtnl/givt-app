import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/edit_avatar_screen.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/generosity_hunt_button.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/my_givts_text_button.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/color_combo.dart';
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
          backgroundColor: FunTheme.of(context).secondary99,
          body: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                _parentHeaderWidget(activeProfile, context),
                _giveTile(context),
                _generosityHuntButton(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onEditAvatarClicked(BuildContext context, bool trackEvent) {
    Navigator.of(context).push(
      EditAvatarScreen(userGuid: widget.profile.id).toRoute(context),
    );
    if (trackEvent) {
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.editAvatarPictureClicked,
      );
    }
  }

  Widget _giveTile(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: FunTile(
          onTap: () {
            context.pushNamed(
              FamilyPages.giveByListFamily.name,
              extra: {
                'shouldAuthenticate': true,
              },
            );

            // Track analytics event
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.parentGiveTileClicked,
            );
          },
          borderColor: ColorCombo.secondary.borderColor,
          backgroundColor: ColorCombo.secondary.backgroundColor,
          textColor: ColorCombo.secondary.textColor,
          iconPath: 'assets/family/images/give_tile.svg',
          titleBig: 'Give',
          analyticsEvent: AmplitudeEvents.parentGiveTileClicked.toEvent(),
        ),
      );

  Widget _generosityHuntButton(BuildContext context, ProfilesState state) {
    if (!state.showBarcodeHunt) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: GenerosityHuntButton(
        analyticsEvent: AmplitudeEvents.parentGenerosityHuntButtonClicked.toEvent(),
        onPressed: () {
          // Set the current profile as active and navigate to the game
          context.read<ProfilesCubit>().setActiveProfile(
            state.activeProfile.id,
          );
          context.goNamed(FamilyPages.newGame.name);
        },
      ),
    );
  }

  FunTopAppBar _topAppBar(Profile profile, BuildContext context) =>
      FunTopAppBar(
        title: profile.firstName,
        color: FunTheme.of(context).secondary99,
        systemNavigationBarColor: FunTheme.of(context).secondary99,
        leading: const GivtBackButtonFlat(),
      );

  Widget _parentHeaderWidget(Profile profile, BuildContext context) =>
      Container(
        width: MediaQuery.sizeOf(context).width,
        color: FunTheme.of(context).secondary99,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: MediaQuery.sizeOf(context).width,
              child: SvgPicture.asset(
                'assets/family/images/parent_home_background.svg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _onEditAvatarClicked(context, true),
                  child: FunAvatar.fromProfile(profile, size: 100),
                ),
                const SizedBox(height: 12),
                FunButton(
                  variant: FunButtonVariant.secondary,
                  fullBorder: true,
                  onTap: () => _onEditAvatarClicked(context, false),
                  text: 'Edit avatar',
                  analyticsEvent: AmplitudeEvents.editProfilePictureClicked.toEvent(),
                  size: FunButtonSize.small,
                  leftIcon: FontAwesomeIcons.userPen,
                  funButtonBadge: FunButtonBadge(
                    featureId: Features.profileEditAvatarButton,
                    profileId: profile.id,
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
          ],
        ),
      );
}
