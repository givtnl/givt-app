import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/widgets/give_bottomsheet.dart';
import 'package:givt_app/features/family/features/profiles/widgets/wallet_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  bool isiPad = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    isIpadCheck().then(
      (value) => setState(() {
        isiPad = value;
      }),
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('state = $state');
    if (AppLifecycleState.resumed == state) {
      refresh();
    }
  }

  Future<void> refresh() async {
    // Execute tasks in parallel
    await Future.wait([
      context.read<ProfilesCubit>().refresh(),
    ]);
  }

  Future<bool> isIpadCheck() async {
    if (Platform.isAndroid) return false;

    final deviceInfo = DeviceInfoPlugin();
    if (deviceInfo.deviceInfo is IosDeviceInfo) {
      final info = await deviceInfo.iosInfo;
      if (info.model.isNotEmpty && info.model.toLowerCase().contains('ipad')) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        final hasDonations = state.activeProfile.hasDonations;

        var countdownAmount = 0.0;
        if (state is ProfilesCountdownState) {
          countdownAmount = state.amount;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: state is ProfilesLoadingState
              ? const CustomCircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: refresh,
                  child: Stack(
                    children: [
                      ListView(),
                      Column(
                        children: [
                          WalletWidget(
                            balance: state.activeProfile.wallet.balance,
                            countdownAmount: countdownAmount,
                            hasDonations: hasDonations,
                            profile: state.activeProfile,
                            kidid: state.activeProfile.id,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: FunTile(
                                      titleBig: 'Give',
                                      iconPath:
                                          'assets/family/images/give_tile.svg',
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      borderColor: Theme.of(context)
                                          .colorScheme
                                          .onInverseSurface,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      analyticsEvent: AnalyticsEvent(
                                        AmplitudeEvents.iWantToGivePressed,
                                        parameters: {
                                          AnalyticsHelper.walletAmountKey: state
                                              .activeProfile.wallet.balance,
                                        },
                                      ),
                                      onTap: () => showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: Colors.white,
                                        builder: (context) => GiveBottomSheet(
                                          isiPad: isiPad,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FunTile(
                                      titleBig: 'Find Charity',
                                      iconPath:
                                          'assets/family/images/find_tile.svg',
                                      backgroundColor: FamilyAppTheme.primary98,
                                      borderColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      analyticsEvent: AnalyticsEvent(
                                        AmplitudeEvents
                                            .helpMeFindCharityPressed,
                                      ),
                                      onTap: () {
                                        context
                                            .read<FlowsCubit>()
                                            .startRecommendationFlow();

                                        context.pushNamed(
                                          FamilyPages.recommendationStart.name,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
