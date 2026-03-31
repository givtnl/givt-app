import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_cubit.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_custom.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_uimodel.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ForYouBeaconDiscoveryPage extends StatefulWidget {
  const ForYouBeaconDiscoveryPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouBeaconDiscoveryPage> createState() =>
      _ForYouBeaconDiscoveryPageState();
}

class _ForYouBeaconDiscoveryPageState extends State<ForYouBeaconDiscoveryPage>
    with WidgetsBindingObserver {
  late final ForYouBeaconDiscoveryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ForYouBeaconDiscoveryCubit>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_cubit.init(widget.flowContext));
        _syncWakelockToCubitState(_cubit.state);
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_cubit.close());
    super.dispose();
  }

  /// Keep the screen awake only while the loading or active beacon search UI
  /// is shown — not on Bluetooth off / permission settings.
  void _syncWakelockToCubitState(
    BaseState<ForYouBeaconDiscoveryUIModel, ForYouBeaconDiscoveryCustom> state,
  ) {
    final shouldHold = switch (state) {
      LoadingState() => true,
      DataState(:final data) =>
        data.phase == ForYouBeaconDiscoveryPhase.searching,
      _ => false,
    };
    if (shouldHold) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_cubit.onAppResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        ForYouBeaconDiscoveryCubit,
        BaseState<ForYouBeaconDiscoveryUIModel, ForYouBeaconDiscoveryCustom>>(
      bloc: _cubit,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        _syncWakelockToCubitState(state);
      },
      child: FunScaffold(
        appBar: const FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: GivtBackButtonFlat(),
        ),
        body:
            BaseStateConsumer<
              ForYouBeaconDiscoveryUIModel,
              ForYouBeaconDiscoveryCustom
            >(
              cubit: _cubit,
              onLoading: (context) => const _SearchingBodyLoader(),
              onData: (context, uiModel) {
                return switch (uiModel.phase) {
                  ForYouBeaconDiscoveryPhase.searching => _SearchingBody(
                    locals: context.l10n,
                  ),
                  ForYouBeaconDiscoveryPhase.bluetoothOff => _BluetoothOffBody(
                    locals: context.l10n,
                    onOpenSettings: () =>
                        unawaited(_cubit.openSystemSettings()),
                  ),
                  ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings =>
                    _PermissionDeniedBody(
                      locals: context.l10n,
                      onOpenSettings: () =>
                          unawaited(_cubit.openSystemSettings()),
                    ),
                };
              },
              onCustom: (context, custom) {
                switch (custom) {
                  case ForYouBeaconNavigateToConfirm(:final flowContext):
                    context.goNamed(
                      Pages.forYouOrganisationConfirm.name,
                      extra: flowContext.toMap(),
                    );
                  case ForYouBeaconNavigateToList(:final flowContext):
                    context.goNamed(
                      Pages.forYouList.name,
                      extra: flowContext.toMap(),
                    );
                }
              },
            ),
      ),
    );
  }
}

/// Shown while the cubit is still loading (before the first data emit).
class _SearchingBodyLoader extends StatelessWidget {
  const _SearchingBodyLoader();

  @override
  Widget build(BuildContext context) {
    return _SearchingBody(locals: context.l10n);
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
        FunIconGivy.bagAnimation(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.forYouBeaconSearchingTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouBeaconSearchingBody,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}

class _BluetoothOffBody extends StatelessWidget {
  const _BluetoothOffBody({
    required this.locals,
    required this.onOpenSettings,
  });

  final AppLocalizations locals;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.bluetoothSettings(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.forYouBluetoothOffTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouBluetoothOffBody,
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

class _PermissionDeniedBody extends StatelessWidget {
  const _PermissionDeniedBody({
    required this.locals,
    required this.onOpenSettings,
  });

  final AppLocalizations locals;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.bluetoothSettings(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.authoriseBluetooth,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.authoriseBluetoothErrorMessage,
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
