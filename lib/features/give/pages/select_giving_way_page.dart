import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/context_list_tile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SelectGivingWayPage extends StatelessWidget {
  const SelectGivingWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;

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
                  context.goNamed(Pages.giveOffline.name);
                }
                if (state.status == GiveStatus.readyToConfirmGPS) {
                  _buildGivingDialog(
                    context,
                    text: context.l10n.givtEventText(
                      state.nearestLocation.name,
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
                  _buildGivingDialog(
                    context,
                    text: context.l10n.qrScannedOutOfApp(
                      state.organisation.organisationName!,
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
              },
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
        ],
      ),
    );
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
          size: 18,
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
