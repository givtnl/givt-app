import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/action_tile.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final profile = state.profiles.firstWhere((p) => p.id == id);
        return Scaffold(
          appBar: _topAppBar(profile, context),
          backgroundColor: AppTheme.secondary99,
          body: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                _parentHeaderWidget(profile, context),
                _giveTile(context),
              ],
            ),
          ),
          bottomNavigationBar: _fakeAppBar(context),
        );
      },
    );
  }

  void _onMySettingsClicked(BuildContext context) {
    context.pushNamed(
      FamilyPages.familyPersonalInfoEdit.name,
      extra: true,
    );
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.mySettingsClicked,
    );
  }

  void _onProfileSwitchPressed(BuildContext context) {
    context.read<ProfilesCubit>().fetchAllProfiles();
    context.pop();
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.profileSwitchPressed,
    );
  }

  Widget _fakeAppBar(BuildContext context) => SafeArea(
        child: Container(
          color: AppTheme.secondary99,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.secondary95,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  child: SvgPicture.asset(
                    NavigationDestinationData.home.iconPath,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                NavigationDestinationData.home.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget _giveTile(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: ActionTile(
          onTap: () {
            context.pushNamed(FamilyPages.giveByListFamily.name);
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.parentGiveTileClicked,
            );
          },
          borderColor: ColorCombo.secondary.borderColor,
          backgroundColor: ColorCombo.secondary.backgroundColor,
          textColor: ColorCombo.secondary.textColor,
          iconPath: 'assets/family/images/give_tile.svg',
          titleBig: 'Give',
        ),
      );

  TopAppBar _topAppBar(Profile profile, BuildContext context) => TopAppBar(
        title: profile.firstName,
        color: AppTheme.secondary99,
        actions: [
          IconButton(
            icon: switchProfilesIcon(),
            onPressed: () => _onProfileSwitchPressed(context),
          ),
        ],
      );

  Widget _parentHeaderWidget(Profile profile, BuildContext context) =>
      Container(
        width: MediaQuery.sizeOf(context).width,
        color: AppTheme.secondary99,
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
              onTap: () => _onMySettingsClicked(context),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Settings',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          FontAwesomeIcons.arrowRight,
                          size:
                              Theme.of(context).textTheme.labelSmall?.fontSize,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
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
