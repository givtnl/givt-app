import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/family_home_screen_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_overlay.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class FamilyHomeScreen extends StatefulWidget {
  const FamilyHomeScreen({super.key});

  @override
  State<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends State<FamilyHomeScreen> {
  OverlayEntry? overlayEntry;
  bool overlayVisible = false;
  final _cubit = getIt<FamilyHomeScreenCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<ProfilesCubit>().fetchAllProfiles();
    _cubit.init();
  }

  @override
  void dispose() {
    if (overlayEntry != null && overlayEntry!.mounted) {
      closeOverlay();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: (context, uiModel) {
        createOverlay(uiModel);
        setState(() {
          overlayVisible = true;
        });
        Overlay.of(context).insert(overlayEntry!);
      },
      onData: (context, uiModel) {
        return FunScaffold(
          minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          appBar: const FunTopAppBar(title: null),
          body: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/family/images/home_screen/background.svg',
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TitleLargeText(
                          overlayVisible
                              ? ''
                              : uiModel.familyGroupName == null
                                  ? 'Welcome!'
                                  : 'Hey ${uiModel.familyGroupName}!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!overlayVisible)
                        AvatarBar(
                          circleSize: 58,
                          uiModel: AvatarBarUIModel(
                            avatarUIModels: uiModel.avatars,
                          ),
                          onAvatarTapped: onAvatarTapped,
                        ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    GratitudeGameButton(
                      onPressed: () => context.goNamed(
                        FamilyPages.reflectIntro.name,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GiveButton(
                      onPressed: _cubit.onGiveButtonPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void createOverlay(FamilyHomeScreenUIModel uiModel) {
    overlayEntry = OverlayEntry(
      builder: (context) => FamilyHomeOverlay(
        uiModel: uiModel,
        onDismiss: closeOverlay,
        onAvatarTapped: onAvatarTapped,
      ),
    );
  }

  Future<void> onAvatarTapped(int index) async {
    if (overlayVisible) {
      closeOverlay();
    }

    var profile = _cubit.profiles[index];

    unawaited(
      context.read<ProfilesCubit>().setActiveProfile(
            profile.id,
          ),
    );

    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.profilePressed,
        eventProperties: {
          'profile_id': profile.id,
          'profile_name': profile.firstName,
        },
      ),
    );

    if (profile.profileType == ProfileType.Parent) {
      if (profile.id != context.read<AuthCubit>().state.user.guid) {
        return;
      }

      await FamilyAuthUtils.authenticateUser(
        context,
        checkAuthRequest: CheckAuthRequest(
          navigate: (context, {isUSUser}) async {
            await context.pushNamed(
              FamilyPages.parentHome.name,
              extra: profile,
            );
            await AnalyticsHelper.setUserProperties(
              userId: profile.id,
            );
          },
        ),
      );
    } else {
      context.goNamed(
        FamilyPages.wallet.name,
        extra: profile,
      );
    }
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;

    setState(() {
      overlayVisible = false;
    });
  }
}
