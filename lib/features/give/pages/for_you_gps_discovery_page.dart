import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

enum _DiscoveryState {
  searching,
  noOrgFound,
  locationOff,
  permissionDenied,
  multipleOrgsFound,
}

class ForYouGpsDiscoveryPage extends StatefulWidget {
  const ForYouGpsDiscoveryPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouGpsDiscoveryPage> createState() => _ForYouGpsDiscoveryPageState();
}

class _ForYouGpsDiscoveryPageState extends State<ForYouGpsDiscoveryPage> {
  StreamSubscription<Position>? _positionSubscription;
  _DiscoveryState _state = _DiscoveryState.searching;
  bool _isResolvingOrg = false;
  late final DateTime _startTime;
  List<CollectGroup> _nearbyOrgs = [];

  static const _minimumSearchDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
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
      await _handlePermissionFailure();
      return;
    }

    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 2,
            timeLimit: Duration(seconds: 120),
          ),
        ).listen(
          (Position? position) async {
            if (!mounted) return;
            if (position == null) return;
            if (_isResolvingOrg) return;

            _isResolvingOrg = true;
            await _resolveFromPositionAndNavigate(position);
          },
          onError: (_) async {
            if (mounted) {
              await _waitForMinimumDuration();
              if (mounted) setState(() => _state = _DiscoveryState.noOrgFound);
            }
          },
        );
  }

  Future<void> _waitForMinimumDuration() async {
    final elapsed = DateTime.now().difference(_startTime);
    if (elapsed < _minimumSearchDuration) {
      await Future<void>.delayed(_minimumSearchDuration - elapsed);
    }
  }

  Future<void> _handlePermissionFailure() async {
    await _waitForMinimumDuration();
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;

    if (!isEnabled) {
      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouLocationServiceOff,
      );
      setState(() => _state = _DiscoveryState.locationOff);
      return;
    }

    await AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.forYouLocationPermissionDenied,
    );
    setState(() => _state = _DiscoveryState.permissionDenied);
  }

  Future<void> _resolveFromPositionAndNavigate(Position position) async {
    try {
      final nearbyOrgs = await ForYouDiscoveryResolvers.resolveNearbyCollectGroups(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      if (nearbyOrgs.isEmpty) {
        await _waitForMinimumDuration();
        await AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.forYouLocationNoOrgFound,
        );
        if (mounted) setState(() => _state = _DiscoveryState.noOrgFound);
        return;
      }

      // Multiple organizations at the same location
      if (nearbyOrgs.length > 1) {
        await AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.forYouLocationMultipleOrgsFound,
        );
        if (mounted) {
          setState(() {
            _nearbyOrgs = nearbyOrgs;
            _state = _DiscoveryState.multipleOrgsFound;
          });
        }
        return;
      }

      // Single organization found
      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouOrganisationSelected,
      );

      if (!mounted) return;
      context.goNamed(
        Pages.forYouOrganisationConfirm.name,
        extra: widget.flowContext
            .copyWith(selectedOrganisation: nearbyOrgs.first)
            .toMap(),
      );
    } finally {
      await _positionSubscription?.cancel();
    }
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  Future<void> _selectOrganisation(CollectGroup org) async {
    await AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.forYouLocationOrganisationSelected,
    );

    if (!mounted) return;
    context.goNamed(
      Pages.forYouGiving.name,
      extra: widget.flowContext
          .copyWith(selectedOrganisation: org)
          .toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: GivtBackButtonFlat(),
      ),
      body: switch (_state) {
        _DiscoveryState.searching => _SearchingBody(locals: locals),
        _DiscoveryState.noOrgFound => _NoOrgFoundBody(locals: locals),
        _DiscoveryState.locationOff => _LocationProblemBody(
          locals: locals,
          title: locals.forYouLocationOffTitle,
          body: locals.forYouLocationOffBody,
          onOpenSettings: _openSettings,
        ),
        _DiscoveryState.permissionDenied => _LocationProblemBody(
          locals: locals,
          title: locals.forYouLocationPermissionTitle,
          body: locals.forYouLocationPermissionBody,
          onOpenSettings: _openSettings,
        ),
        _DiscoveryState.multipleOrgsFound => _MultipleOrgsFoundBody(
          locals: locals,
          organisations: _nearbyOrgs,
          onSelectOrganisation: _selectOrganisation,
        ),
      },
    );
  }
}

class _SearchingBody extends StatelessWidget {
  const _SearchingBody({required this.locals});

  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.searching(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.forYouLocationSearchingTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouLocationSearchingBody,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}

class _NoOrgFoundBody extends StatelessWidget {
  const _NoOrgFoundBody({required this.locals});

  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.sad(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.forYouLocationNoOrgFoundTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouLocationNoOrgFoundBody,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}

class _LocationProblemBody extends StatelessWidget {
  const _LocationProblemBody({
    required this.locals,
    required this.title,
    required this.body,
    required this.onOpenSettings,
  });

  final AppLocalizations locals;
  final String title;
  final String body;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.sad(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          body,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FunButton(
          text: locals.forYouLocationOpenSettings,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.forYouLocationOpenSettingsTapped,
          ),
          onTap: onOpenSettings,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MultipleOrgsFoundBody extends StatelessWidget {
  const _MultipleOrgsFoundBody({
    required this.locals,
    required this.organisations,
    required this.onSelectOrganisation,
  });

  final AppLocalizations locals;
  final List<CollectGroup> organisations;
  final void Function(CollectGroup) onSelectOrganisation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final funTheme = FunTheme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
            child: Column(
              children: [
                FunIconGivy.searching(circleSize: 140),
                const SizedBox(height: 28),
                TitleLargeText(
                  locals.forYouLocationMultipleOrgsFoundTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                BodyMediumText(
                  locals.forYouLocationMultipleOrgsFoundBody,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: organisations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final org = organisations[index];
              final iconData = CollectGroupType.getIconByType(org.type);
              
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelectOrganisation(org),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.brightness == Brightness.light
                            ? Colors.grey.shade200
                            : Colors.grey.shade700,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: funTheme.primary95,
                          child: Icon(
                            iconData,
                            color: funTheme.primary20,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TitleLargeText(
                            org.orgName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: theme.brightness == Brightness.light
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
