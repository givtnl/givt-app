import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({
    required this.balance,
    required this.hasDonations,
    super.key,
    this.avatarUrl = '',
    this.countdownAmount = 0,
  });

  final double balance;
  final bool hasDonations;
  final double countdownAmount;
  final String avatarUrl;

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  final AppConfig _appConfig = getIt();

  Future<String> _getAppIDAndVersion() async {
    final packageInfo = _appConfig.packageInfo;
    final result =
        '${packageInfo.packageName} v${packageInfo.version}(${packageInfo.buildNumber})';
    return result;
  }

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
                          context
                              .pushNamed(FamilyPages.kidsAvatarSelection.name);
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvents.editProfilePictureClicked,
                          );
                        },
                        customBorder: const CircleBorder(),
                        splashColor: Theme.of(context).primaryColor,
                        onDoubleTap: () async {
                          final appInfoString = await _getAppIDAndVersion();

                          if (!context.mounted) return;
                          SnackBarHelper.showMessage(
                            context,
                            text: appInfoString,
                          );
                        },
                        child: SvgPicture.network(
                          widget.avatarUrl,
                          width: 100,
                        ),
                      ),
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
                          color: AppTheme.info40,
                          size: 20,
                        ),
                        Countup(
                          begin: widget.balance + widget.countdownAmount,
                          end: widget.balance,
                          duration: const Duration(seconds: 3),
                          separator: '.',
                          prefix: r' $',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.topCenter,
                    ),
                    onPressed: () {
                      SystemSound.play(SystemSoundType.click);
                      context.pushNamed(FamilyPages.kidsAvatarSelection.name);
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.editAvatarIconClicked,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My profile',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            size: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
