import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/context_list_tile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SelectGivingWayPage extends StatelessWidget {
  const SelectGivingWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          locals.selectContext,
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 130),
            height: size.height,
            width: size.width,
            color: AppTheme.givtGraycece,
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: BlocListener<GiveBloc, GiveState>(
              listener: (context, state) {
                if (state.status == GiveStatus.noInternetConnection) {
                  context.goNamed(
                    Pages.giveSucess.name,
                    extra: {
                      'isRecurringDonation': false,
                      'orgName': state.organisation.organisationName,
                    },
                  );
                }
                if (state.status == GiveStatus.error) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => WarningDialog(
                      title: locals.errorOccurred,
                      content: locals.errorContactGivt,
                      onConfirm: () => context.pop(),
                    ),
                  );
                }
                if (state.status ==
                    GiveStatus.donatedToSameOrganisationInLessThan30Seconds) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => WarningDialog(
                      title: locals.notSoFast,
                      content: locals.giftBetween30Sec,
                      onConfirm: () => context.pop(),
                    ),
                  );
                }
                if (state.status == GiveStatus.readyToConfirmGPS) {
                  _buildGivingDialog(
                    context,
                    text: context.l10n.givtEventText(
                      state.organisation.organisationName!,
                    ),
                    image: 'assets/images/select_location.png',
                    onTap: () => context.read<GiveBloc>().add(
                          GiveGPSConfirm(
                            context.read<AuthCubit>().state.user.guid,
                          ),
                        ),
                  );
                  return;
                }
                if (state.status == GiveStatus.readyToConfirm) {
                  var orgName = state.organisation.organisationName!;
                  if (state.instanceName.isNotEmpty) {
                    orgName = '$orgName: ${state.instanceName}';
                  }
                  _buildGivingDialog(
                    context,
                    text: context.l10n.qrScannedOutOfApp(
                      orgName,
                    ),
                    image: 'assets/images/select_qr_phone_scan.png',
                    onTap: () => context.read<GiveBloc>().add(
                          const GiveConfirmQRCodeScannedOutOfApp(),
                        ),
                  );
                }
                if (state.status == GiveStatus.readyToGive) {
                  context.goNamed(
                    Pages.give.name,
                    extra: context.read<GiveBloc>(),
                  );
                }

                if (state.status == GiveStatus.beaconNotActive) {
                  _buildInvalidQRCodeDialog(context, state, user.guid);
                }
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        locals.giveSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
                      builder: (context, state) {
                        if (state.status == GoalTrackerStatus.activeGoal) {
                          return _buildListTile(
                            onTap: () => log('Give to family goal'),
                            title: locals.yourFamilyGoalKey,
                            subtitle:
                                'Give to ${state.organisation.organisationName}',
                            image: 'assets/images/select_goal_list_tile.png',
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    _buildListTile(
                      onTap: () => context.goNamed(
                        Pages.giveByBeacon.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      title: locals.givingContextCollectionBag,
                      subtitle: locals.selectContextCollect,
                      image: 'assets/images/select_givtbox.png',
                    ),
                    _buildListTile(
                      onTap: () => context.goNamed(
                        Pages.giveByQrCode.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      title: locals.givingContextQrCode,
                      subtitle: locals.giveContextQr,
                      image: 'assets/images/select_qr_phone_scan.png',
                    ),
                    _buildListTile(
                      onTap: () => context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      title: locals.givingContextCollectionBagList,
                      subtitle: locals.selectContextList,
                      image: 'assets/images/select_list.png',
                    ),
                    _buildListTile(
                      onTap: () => context.goNamed(
                        Pages.giveByLocation.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      title: locals.givingContextLocation,
                      subtitle: locals.selectLocationContextLong,
                      image: 'assets/images/select_location.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildInvalidQRCodeDialog(
    BuildContext context,
    GiveState state,
    String guid,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.invalidQRcodeTitle,
        content: context.l10n.invalidQRcodeMessage(
          state.organisation.organisationName!,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => context.pop(true),
            child: Text(
              context.l10n.cancel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => context.read<GiveBloc>().add(
                  GiveOrganisationSelected(
                    state.organisation.mediumId!,
                    guid,
                  ),
                ),
            child: Text(
              context.l10n.yesPlease,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).then((cancel) {
      if (cancel == null) {
        return;
      }
      if (cancel) {
        context.pop();
      }
    });
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required String image,
  }) =>
      ContextListTile(
        onTap: onTap,
        leading: Image.asset(
          image,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        title: title,
        subtitle: subtitle,
      );

  Future<void> _buildGivingDialog(
    BuildContext context, {
    required String text,
    required String image,
    required VoidCallback onTap,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Image.asset(
          image,
          width: 50,
        ),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: onTap,
            child: Text(
              context.l10n.yesPlease,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
