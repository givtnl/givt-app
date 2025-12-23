import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/edit_avatar_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/my_givts_text_button.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({
    required this.balance,
    required this.hasDonations,
    super.key,
    this.profile,
    this.kidid = '',
    this.countdownAmount = 0,
  });

  final double balance;
  final bool hasDonations;
  final double countdownAmount;
  final Profile? profile;
  final String kidid;

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.sizeOf(context).width,
            child: SvgPicture.asset(
              'assets/family/images/wallet_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          BlocBuilder<ProfilesCubit, ProfilesState>(
            builder: (context, state) {
              return Column(
                children: [
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          SystemSound.play(SystemSoundType.click);
                          Navigator.of(context).push(
                            EditAvatarScreen(userGuid: widget.kidid).toRoute(
                              context,
                            ),
                          );
                          AnalyticsHelper.logEvent(
                            eventName:
                                AnalyticsEventName.editProfilePictureClicked,
                          );
                        },
                        customBorder: const CircleBorder(),
                        splashColor: Theme.of(context).primaryColor,
                        child: widget.profile == null
                            ? FunAvatar.defaultHero()
                            : FunAvatar.fromProfile(widget.profile!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FunButton.secondary(
                    onTap: () {
                      Navigator.of(context).push(
                        EditAvatarScreen(userGuid: widget.kidid).toRoute(
                          context,
                        ),
                      );
                    },
                    text: 'Edit avatar',
                    analyticsEvent: AnalyticsEventName.editProfilePictureClicked
                        .toEvent(),
                    size: FunButtonSize.small,
                    leftIcon: FontAwesomeIcons.userPen,
                    funButtonBadge: FunButtonBadge(
                      featureId: Features.profileEditAvatarButton,
                      profileId: widget.kidid,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state is ProfilesLoadingState)
                    const CustomCircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.wallet,
                          color: FamilyAppTheme.info40,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Countup(
                          begin: widget.balance + widget.countdownAmount,
                          end: widget.balance,
                          duration: const Duration(seconds: 3),
                          separator: '.',
                          prefix: r' $',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  MyGivtsButton(
                    userId: widget.kidid,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
