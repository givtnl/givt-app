import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
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

class FamilyHomeScreen extends StatelessWidget {
  const FamilyHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().state.user.lastName;
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final proiles = context.watch<ProfilesCubit>().state.profiles;
        return FunScaffold(
          minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          appBar: const FunTopAppBar(title: null),
          body: state is ProfilesLoadingState || state is ProfilesInvitedToGroup
              ? const CustomCircularProgressIndicator()
              : state.profiles.isEmpty && state.cachedMembers.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () =>
                          context.read<ProfilesCubit>().fetchAllProfiles(
                                doChecks: true,
                              ),
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
                                    'Hey ${name} Family!',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getBarPadding(
                                            context: context,
                                            circleSize: 58,
                                            profilesLength: proiles.length)),
                                    child: GratefulAvatarBar(
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
                                      onAvatarTapped: (index) {
                                        //TODO: KIDS-1461
                                      },
                                    ),
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
                                  //TODO: KIDS-1461
                                  //path to logout during dev
                                  context.goNamed(
                                      FamilyPages.childrenOverview.name);
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

  double getBarPadding(
      {required BuildContext context,
      required int circleSize,
      required int profilesLength}) {
    if (profilesLength > 5) {
      return 0;
    } else {
      final width = MediaQuery.of(context).size.width;
      final value = (width - (circleSize + 24) * profilesLength - 24) / 2;
      return value;
    }
  }
}
