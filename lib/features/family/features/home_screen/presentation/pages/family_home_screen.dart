import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/family_home_screen_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_overlay.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
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
  final _cubit = getIt<FamilyHomeScreenCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cubit.init();
  }

  @override
  void initState() {
    super.initState();
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
      onLoading: (context) => const CustomCircularProgressIndicator(),
      onData: (context, uiModel) {
        createOverlay(uiModel);

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        TitleLargeText(
                          overlayVisible
                              ? ''
                              : 'Hey ${uiModel.familyGroupName}!',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        GratefulAvatarBar(
                          circleSize: 58,
                          uiModel: GratefulAvatarBarUIModel(
                            avatarUIModels: uiModel.avatars,
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

  void createOverlay(FamilyHomeScreenUIModel uiModel) {
    if (overlayEntry != null) return;

    overlayEntry = OverlayEntry(
      builder: (context) => FamilyHomeOverlay(
        uiModel: uiModel,
        onDismiss: closeOverlay,
        onAvatarTapped: onAvatarTapped,
      ),
    );
  }

  void onAvatarTapped(int index) {
    if (overlayVisible) {}

    context.goNamed(FamilyPages.reflectIntro.name);
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
