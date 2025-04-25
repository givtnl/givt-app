import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/dialogs/give_loading_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSScanPage extends StatefulWidget {
  const GPSScanPage({
    super.key,
    this.isSelection = false,
  });

  final bool isSelection;

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

  void _handleLocationFound(BuildContext context, GiveState state) {
    final userGUID = context.read<AuthCubit>().state.user.guid;

    if (widget.isSelection && state.nearestLocation.beaconId.isNotEmpty) {
      // In selection mode, fetch the CollectGroup and return it via Navigator.pop()
      final collectGroupRepository = context.read<CollectGroupRepository>();
      collectGroupRepository.getCollectGroupList().then((collectGroupList) {
        try {
          final namespace = state.nearestLocation.beaconId.split('.').first;
          final collectGroup = collectGroupList.firstWhere(
            (group) => group.nameSpace == namespace,
            orElse: () => const CollectGroup.empty(),
          );

          if (collectGroup.nameSpace.isNotEmpty) {
            context.pop(collectGroup);
          } else {
            LoggingInfo.instance.warning(
              'No matching CollectGroup found for GPS location: ${state.nearestLocation.name}',
            );
            _showNoOrganizationFoundDialog(context);
          }
        } catch (e, stackTrace) {
          LoggingInfo.instance.error(
            'Error finding CollectGroup: ${e.toString()}',
            methodName: stackTrace.toString(),
          );
          _showNoOrganizationFoundDialog(context);
        }
      });
    } else {
      // Original behavior for non-selection mode
      if (state.organisation.organisationName?.isNotEmpty == true) {
        context.read<GiveBloc>().add(
              GiveGPSConfirm(userGUID),
            );
      } else {
        context.goNamed(
          Pages.giveByList.name,
          extra: context.read<GiveBloc>(),
        );
      }
    }
  }

  void _showNoOrganizationFoundDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.unknownError,
        content: context.l10n.somethingWentWrong,
        onConfirm: () => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.selectLocationContext),
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
                Text(
                  locals.searchingEventText,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const AnimatedGivyImage(
                  image: 'assets/images/givy_lookout.png',
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        GiveLoadingDialog.showGiveLoadingDialog(context);
                        _handleLocationFound(context, state);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.givtBlue,
                      ),
                      child: Text(
                        orgName.isEmpty
                            ? locals.giveDifferently
                            : locals.giveToNearestBeacon(
                                state.organisation.organisationName!,
                              ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisible && orgName.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextButton(
                      onPressed: () => context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(locals.giveDifferently),
                    ),
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
