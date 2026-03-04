import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/navigation.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/dialogs/give_loading_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSScanPage extends StatefulWidget {
  const GPSScanPage({
    super.key,
  });

  @override
  State<GPSScanPage> createState() => _GPSScanPageState();
}

class _GPSScanPageState extends State<GPSScanPage> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    initGPS();
  }

  Future<void> initGPS() async {
    final permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse ||
        permission != LocationPermission.always) {
      await _permissionCheck();
    }
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
        timeLimit: Duration(seconds: 120),
      ),
    ).listen(
      onError: (Object? error) => LoggingInfo.instance.error(
        'Error in GPS scan page: $error',
        methodName: 'initGPS',
      ),
      (Position? position) {
        if (position == null) {
          return;
        }
        if (!mounted) {
          return;
        }
        context.read<GiveBloc>().add(
          GiveGPSLocationChanged(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      },
      onDone: () {
        log('Done');
      },
    );
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) {
        return;
      }
      setState(() {
        isVisible = !isVisible;
      });
    });
  }

  Future<void> _permissionCheck() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) => WarningDialog(
          title: context.l10n.allowGivtLocationTitle,
          content: context.l10n.locationEnabledMessage,
          onConfirm: () {
            openAppSettings();
            context.pop();
          },
        ),
      );
    }
    await Geolocator.checkPermission().then((permission) {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) {
          return;
        }
        showDialog<void>(
          context: context,
          builder: (_) => WarningDialog(
            title: context.l10n.allowGivtLocationTitle,
            content: context.l10n.allowGivtLocationMessage,
            onConfirm: () {
              openAppSettings();
              context.pop();
            },
          ),
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: const GivtBackButtonFlat(),
        title: locals.selectLocationContext,
      ),
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) {},
          builder: (context, state) {
            var orgName = state.organisation.organisationName;
            orgName ??= '';
            return Column(
              children: [
                const SizedBox(height: 50),
                BodyMediumText(
                  locals.searchingEventText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const AnimatedGivyImage(
                  image: 'assets/images/givy_lookout.png',
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: isVisible,
                  child: FunButton(
                    analyticsEvent: AmplitudeEvents.giveButtonPressed.toEvent(),
                    onTap: () {
                      GiveLoadingDialog.showGiveLoadingDialog(context);
                      if (orgName!.isNotEmpty) {
                        context.read<GiveBloc>().add(
                          GiveToLastOrganisation(
                            context.read<AuthCubit>().state.user.guid,
                          ),
                        );
                        return;
                      }
                      context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      );
                    },
                    text: orgName.isEmpty
                        ? locals.giveDifferently
                        : locals.giveToNearestBeacon(
                            state.organisation.organisationName!,
                          ),
                  ),
                ),
                Visibility(
                  visible: isVisible && orgName.isNotEmpty,
                  child: FunTextButton(
                    analyticsEvent: AmplitudeEvents.giveButtonPressed.toEvent(),
                    onTap: () => context.goNamed(
                      Pages.giveByList.name,
                      extra: context.read<GiveBloc>(),
                    ),
                    text: locals.giveDifferently,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedGivyImage extends StatefulWidget {
  const AnimatedGivyImage({
    required this.image,
    super.key,
  });

  final String image;

  @override
  State<AnimatedGivyImage> createState() => _AnimatedGivyImageState();
}

class _AnimatedGivyImageState extends State<AnimatedGivyImage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animation = Tween<double>(begin: 20, end: -20).animate(animController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animController.forward();
        }
      });

    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          widget.image,
          width: 200,
          height: 200,
        ),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
    );
  }
}
