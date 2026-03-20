import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:givt_app/utils/analytics_helper.dart';

class ForYouGpsDiscoveryPage extends StatefulWidget {
  const ForYouGpsDiscoveryPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouGpsDiscoveryPage> createState() =>
      _ForYouGpsDiscoveryPageState();
}

class _ForYouGpsDiscoveryPageState extends State<ForYouGpsDiscoveryPage> {
  StreamSubscription<Position>? _positionSubscription;
  bool _isResolving = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    final permission = await Geolocator.requestPermission();
    if (!mounted) return;

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      await _permissionCheckAndFallbackIfNeeded();
      return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
        timeLimit: Duration(seconds: 120),
      ),
    ).listen(
      (Position? position) async {
        if (!mounted) return;
        if (position == null) return;
        if (_isResolving) return;

        setState(() => _isResolving = true);
        await _resolveFromPositionAndNavigate(position);
      },
      onError: (_) {
        // If GPS fails, just let the user choose from list.
        if (!_isResolving && mounted) {
          _goToList();
        }
      },
    );
  }

  Future<void> _permissionCheckAndFallbackIfNeeded() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      if (!mounted) return;
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
      _goToList();
      return;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      await showDialog<void>(
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
      _goToList();
    }
  }

  Future<void> _resolveFromPositionAndNavigate(Position position) async {
    try {
      final collectGroup = await ForYouDiscoveryResolvers.resolveNearestCollectGroup(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      if (collectGroup == null) {
        _goToList();
        return;
      }

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouOrganisationSelected,
      );

      if (!mounted) return;
      context.goNamed(
        Pages.forYouGiving.name,
        extra: widget.flowContext
            .copyWith(selectedOrganisation: collectGroup)
            .toMap(),
      );
    } finally {
      if (mounted) {
        await _positionSubscription?.cancel();
      }
    }
  }

  void _goToList() {
    if (!mounted) return;
    context.goNamed(
      Pages.forYouList.name,
      extra: widget.flowContext.toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const GivtBackButtonFlat(),
        title: Text(locals.selectLocationContext),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BodyMediumText(
                locals.searchingEventText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (_isResolving) const CircularProgressIndicator(),
              if (!_isResolving) ...[
                const SizedBox(height: 20),
                const Image(
                  image: AssetImage('assets/images/givy_lookout.png'),
                  width: 240,
                  height: 240,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _goToList,
                  child: Text(locals.giveDifferently),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

