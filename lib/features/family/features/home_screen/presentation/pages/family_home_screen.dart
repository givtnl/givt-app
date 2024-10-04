import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_overlay.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profiles_empty_state_widget.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class FamilyHomeScreen extends StatefulWidget {
  const FamilyHomeScreen({super.key});

  @override
  State<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends State<FamilyHomeScreen> {
  OverlayEntry? overlayEntry;
  bool overlayVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfilesCubit>().fetchAllProfiles();

    overlayEntry = OverlayEntry(
      builder: (context) => FamilyHomeOverlay(
        onDismiss: closeOverlay,
        onAvatarTapped: onAvatarTapped,
      ),
    );
  }

  @override
  void dispose() {
    if (overlayEntry != null && overlayEntry!.mounted) {
      closeOverlay();
      overlayEntry?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().state.user.lastName;
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final proiles = context.watch<ProfilesCubit>().state.profiles;
        return FunScaffold(
          minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          appBar: const FunTopAppBar(title: null),
          body: state is ProfilesLoadingState
              ? const CustomCircularProgressIndicator()
              : state.profiles.isEmpty && state.cachedMembers.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () =>
                          context.read<ProfilesCubit>().fetchAllProfiles(),
                    )
                  : Column(
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  TitleLargeText(
                                    overlayVisible ? '' : 'Hey $name Family!',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  GratefulAvatarBar(
                                    circleSize: 58,
                                    uiModel: GratefulAvatarBarUIModel(
                                      avatarUIModels: proiles
                                          .map((e) => GratefulAvatarUIModel(
                                                avatarUrl: e.pictureURL,
                                                text: e.firstName,
                                              ))
                                          .toList(),
                                    ),
                                    withLeftPadding: false,
                                    onAvatarTapped: onAvatarTapped,
                                  ),
                                ],
                              ),
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
                                onPressed: () {
                                  setState(() {
                                    overlayVisible = true;
                                  });

                                  Overlay.of(context).insert(overlayEntry!);
                                },
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

  void onAvatarTapped(int index) {
    if (overlayVisible) {}

    context.goNamed(FamilyPages.reflectIntro.name);
  }

  void closeOverlay() {
    setState(() {
      overlayVisible = false;
    });
    overlayEntry?.remove();
  }
}
