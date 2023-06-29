import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSScanPage extends StatefulWidget {
  const GPSScanPage({super.key});

  @override
  State<GPSScanPage> createState() => _GPSScanPageState();
}

class _GPSScanPageState extends State<GPSScanPage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _permissionCheck();
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
        timeLimit: Duration(seconds: 30),
      ),
    ).listen(
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
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  Future<void> _permissionCheck() async {
    final permission = await Permission.location.request();
    if (!permission.isGranted) {
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) => WarningDialog(
          title: context.l10n.allowGivtLocationTitle,
          content: context.l10n.allowGivtLocationMessage,
          onConfirm: openAppSettings,
        ),
      );
      return;
    }
    await Geolocator.isLocationServiceEnabled().then((isEnabled) {
      if (isEnabled) {
        return;
      }
      showDialog<void>(
        context: context,
        builder: (_) => WarningDialog(
          title: context.l10n.allowGivtLocationTitle,
          content: context.l10n.locationEnabledMessage,
          onConfirm: openAppSettings,
        ),
      );
    });
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
                  visible: _isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (orgName!.isNotEmpty) {
                          context.read<GiveBloc>().add(
                                GiveToLastOrganisation(
                                  (context.read<AuthCubit>().state
                                          as AuthSuccess)
                                      .user
                                      .guid,
                                ),
                              );
                          return;
                        }
                        context.goNamed(
                          Pages.giveByList.name,
                          extra: context.read<GiveBloc>(),
                        );
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
                  visible: _isVisible && orgName.isNotEmpty,
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
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    animation = Tween<double>(begin: 10, end: -10).animate(animController)
      ..addListener(() {
        setState(() {});
      })
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
    super.dispose();
    animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          widget.image,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
