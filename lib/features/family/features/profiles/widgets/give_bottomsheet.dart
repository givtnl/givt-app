import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/profiles/widgets/action_tile.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GiveBottomSheet extends StatelessWidget {
  const GiveBottomSheet({
    required this.isiPad,
    required this.familyGoal,
    super.key,
  });

  final bool isiPad;
  final Goal familyGoal;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (familyGoal.isActive)
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ActionTile(
                    isDisabled: false,
                    titleBig: 'Family Goal',
                    subtitle: familyGoal.orgName,
                    iconPath: 'assets/family/images/goal_tile.svg',
                    borderColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundColor: AppTheme.primary98,
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                    onTap: () {
                      context.pop();
                      context.read<FlowsCubit>().startFamilyGoalFlow();
                      final generatedMediumId =
                          base64.encode(familyGoal.mediumId.codeUnits);
                      context
                          .read<OrganisationDetailsCubit>()
                          .getOrganisationDetails(generatedMediumId);
                      final group = context
                          .read<ImpactGroupsCubit>()
                          .state
                          .getGoalGroup(familyGoal);
                      context.pushNamed(
                        FamilyPages.chooseAmountSliderGoal.name,
                        extra: group,
                      );
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.choseGiveToFamilyGoal,
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
                  child: ActionTile(
                    isDisabled: false,
                    titleBig: 'Coin',
                    iconPath: 'assets/family/images/give_with_coin.svg',
                    backgroundColor: AppTheme.highlight98,
                    borderColor: AppTheme.highlight80,
                    textColor: AppTheme.highlight40,
                    onTap: () {
                      context
                        ..pop()
                        ..pushNamed(FamilyPages.scanNFC.name);
                      context.read<FlowsCubit>().startInAppCoinFlow();
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.choseGiveWithCoin,
                      );
                    },
                  ),
                ),
              if (isiPad) const SizedBox() else const SizedBox(width: 16),
              Expanded(
                child: ActionTile(
                  isDisabled: false,
                  titleBig: 'QR Code',
                  iconPath: 'assets/family/images/give_with_qr.svg',
                  borderColor: Theme.of(context).colorScheme.tertiaryContainer,
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  textColor: Theme.of(context).colorScheme.tertiary,
                  onTap: () {
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.choseGiveWithQRCode,
                    );
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
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
