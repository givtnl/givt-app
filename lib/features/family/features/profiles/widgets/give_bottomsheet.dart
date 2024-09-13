import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GiveBottomSheet extends StatelessWidget {
  const GiveBottomSheet({
    required this.isiPad,
    super.key,
  });

  final bool isiPad;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profile = context.read<ProfilesCubit>().state.activeProfile;

    return BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.familyGoal.isActive)
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FunTile(
                        titleBig: 'Family Goal',
                        subtitle: state.familyGoal.orgName,
                        iconPath: 'assets/family/images/goal_tile.svg',
                        borderColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        backgroundColor: FamilyAppTheme.primary98,
                        textColor: Theme.of(context).colorScheme.inversePrimary,
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.choseGiveToFamilyGoal,
                          );

                          if (profile.wallet.balance == 0) {
                            showEmptyWalletBottomSheet(context);
                            return;
                          }

                          context.pop();
                          context.read<FlowsCubit>().startFamilyGoalFlow();
                          final generatedMediumId = base64
                              .encode(state.familyGoal.mediumId.codeUnits);
                          context
                              .read<CollectGroupDetailsCubit>()
                              .getOrganisationDetails(generatedMediumId);
                          final group = state.getGoalGroup(state.familyGoal);
                          context.pushNamed(
                            FamilyPages.chooseAmountSliderGoal.name,
                            extra: group,
                          );
                        },
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),
              const SizedBox(height: 16),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isiPad)
                    const SizedBox()
                  else
                    Expanded(
                      child: FunTile(
                        titleBig: 'Coin',
                        iconPath: 'assets/family/images/give_with_coin.svg',
                        backgroundColor: FamilyAppTheme.highlight98,
                        borderColor: FamilyAppTheme.highlight80,
                        textColor: FamilyAppTheme.highlight40,
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.choseGiveWithCoin,
                          );

                          if (profile.wallet.balance == 0) {
                            showEmptyWalletBottomSheet(context);
                            return;
                          }

                          context
                            ..pop()
                            ..pushNamed(FamilyPages.scanNFC.name);
                          context.read<FlowsCubit>().startInAppCoinFlow();
                        },
                      ),
                    ),
                  if (isiPad) const SizedBox() else const SizedBox(width: 16),
                  Expanded(
                    child: FunTile(
                      titleBig: 'QR Code',
                      iconPath: 'assets/family/images/give_with_qr.svg',
                      borderColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.onTertiary,
                      textColor: Theme.of(context).colorScheme.tertiary,
                      onTap: () {
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.choseGiveWithQRCode,
                        );

                        if (profile.wallet.balance == 0) {
                          showEmptyWalletBottomSheet(context);
                          return;
                        }

                        context.pushNamed(FamilyPages.camera.name);
                        context.read<FlowsCubit>().startInAppQRCodeFlow();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.05),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.cancelGive,
                  );
                },
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  minimumSize: const Size(double.maxFinite, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.xmark,
                      size: 24,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge,
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

  void showEmptyWalletBottomSheet(BuildContext context) {
    context.pop();
    EmptyWalletBottomSheet.show(context);
  }
}
