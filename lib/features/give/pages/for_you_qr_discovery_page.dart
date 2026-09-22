import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/features/give/widgets/camera_permission_eu_dialog.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/errors/scanner_error_widget.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ForYouQrDiscoveryPage extends StatefulWidget {
  const ForYouQrDiscoveryPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouQrDiscoveryPage> createState() => _ForYouQrDiscoveryPageState();
}

class _ForYouQrDiscoveryPageState extends State<ForYouQrDiscoveryPage> {
  final _controller = MobileScannerController();
  final CameraCubit _cameraCubit = getIt<CameraCubit>();

  bool _isProcessing = false;
  bool _isStartingScanner = false;
  double _zoomScale = QrScannerZoom.minScale;
  double _pinchStartZoom = QrScannerZoom.minScale;
  double? _openingZoom;
  bool _ownsZoom = false;
  bool _awaitingOpeningZoom = true;

  double get _restZoom => _openingZoom ?? QrScannerZoom.minScale;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_adoptOpeningZoom);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cameraCubit.checkCameraPermission();
  }

  @override
  void dispose() {
    _controller.removeListener(_adoptOpeningZoom);
    _controller.dispose();
    super.dispose();
  }

  void _beginOpeningCapture() {
    _openingZoom = null;
    _ownsZoom = false;
    _awaitingOpeningZoom = true;
  }

  /// Stores the first real zoom the camera reports after it starts.
  ///
  /// The controller's zoom stays at [QrScannerZoom.maxScale] until the
  /// platform sends a reading. On iOS that placeholder is 5×, not the view
  /// the camera opened on, so it is ignored.
  void _adoptOpeningZoom() {
    if (!_awaitingOpeningZoom || _ownsZoom) {
      return;
    }
    if (!_controller.value.isRunning) {
      return;
    }

    final reported = _controller.value.zoomScale;
    if (reported == QrScannerZoom.maxScale) {
      return;
    }

    _awaitingOpeningZoom = false;
    if (!mounted) {
      return;
    }
    setState(() {
      _openingZoom = reported;
      _zoomScale = reported;
    });
  }

  Future<void> _restartScannerIfMounted() async {
    if (!mounted || _isStartingScanner) {
      return;
    }
    _isStartingScanner = true;
    _beginOpeningCapture();
    try {
      await _controller.start();
    } finally {
      _isStartingScanner = false;
    }
  }

  Future<void> _setZoomScale(double next) async {
    final clamped = QrScannerZoom.clamp(next);
    if (!QrScannerZoom.shouldApply(_zoomScale, clamped)) {
      return;
    }
    if (!_controller.value.isRunning) {
      return;
    }

    setState(() {
      _zoomScale = clamped;
    });

    try {
      await _controller.setZoomScale(clamped);
    } on MobileScannerException {
      return;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _pinchStartZoom = _zoomScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount < 2) {
      return;
    }

    _ownsZoom = true;
    unawaited(
      _setZoomScale(
        QrScannerZoom.fromPinch(
          startScale: _pinchStartZoom,
          gestureScale: details.scale,
        ),
      ),
    );
  }

  void _onZoomToggle() {
    _ownsZoom = true;
    unawaited(
      _setZoomScale(
        QrScannerZoom.toggleTarget(_zoomScale, opening: _restZoom),
      ),
    );
  }

  void _goToForYouList() {
    context.goNamed(
      Pages.forYouList.name,
      extra: widget.flowContext.toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final atRest = QrScannerZoom.isAtRest(_zoomScale, opening: _restZoom);

    return BlocListener<CameraCubit, CameraState>(
      bloc: _cameraCubit,
      listener: (context, state) {
        if (state.status == CameraStatus.permissionPermanentlyDeclined) {
          showDialog<void>(
            context: context,
            builder: (_) => CameraPermissionSettingsEuDialog(
              cameraCubit: _cameraCubit,
              onCancel: () => context.pop(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locals.giveDifferentScan),
              Text(
                locals.giveDiffQrText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          toolbarHeight: MediaQuery.sizeOf(context).height * 0.1,
        ),
        body: Stack(
          children: [
            GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _controller,
                    errorBuilder: (context, error) =>
                        ScannerErrorWidget(error: error),
                    onDetect: (capture) =>
                        _processBarcode(barcodeCapture: capture),
                  ),
                  const Positioned.fill(
                    child: IgnorePointer(child: QrCodeTarget()),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24 + MediaQuery.paddingOf(context).bottom,
              child: Center(
                child: QrScannerZoomButton(
                  isZoomed: !atRest,
                  semanticsLabel: atRest
                      ? locals.forYouQrZoomIn
                      : locals.forYouQrZoomOut,
                  analyticsEvent: AnalyticsEvent(
                    AnalyticsEventName.forYouQrZoomToggled,
                    parameters: {
                      AnalyticsHelper.toggleStatusKey: atRest
                          ? 'zoomed_in'
                          : 'zoomed_out',
                    },
                  ),
                  onPressed: _onZoomToggle,
                ),
              ),
            ),
            if (_isProcessing)
              const Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false),
                ),
              ),
            if (_isProcessing)
              const Positioned.fill(
                child: Center(
                  child: CustomCircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _processBarcode({
    required BarcodeCapture barcodeCapture,
  }) async {
    if (_isProcessing || !mounted) return;
    if (barcodeCapture.barcodes.isEmpty) return;

    final raw = barcodeCapture.barcodes.first.rawValue;
    if (raw == null) return;

    final encodedMediumId = isGivtQRCode(barcodeCapture.barcodes);
    if (encodedMediumId == null) {
      setState(() => _isProcessing = true);
      await _controller.stop();
      if (!mounted) return;
      final tryAgain = await ForYouQrDiscoveryDialogs.showNonGivtQrDialog(
        context,
      );
      if (!mounted) return;
      setState(() => _isProcessing = false);
      if (tryAgain ?? false) {
        await _restartScannerIfMounted();
      } else {
        _goToForYouList();
      }
      return;
    }

    setState(() => _isProcessing = true);
    await _controller.stop();

    try {
      final mediumId = utf8.decode(base64.decode(encodedMediumId));
      final resolved =
          await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
            mediumId,
          );

      if (!mounted) return;

      if (!resolved.isSuccess) {
        await _handleDiscoveryFailure(resolved);
        return;
      }

      final collectGroup = resolved.collectGroup!;
      final qrCode = resolved.qrCode!;
      final restrictToEntryQrGoal = !qrCode.isGeneric;

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouOrganisationSelected,
      );

      if (!mounted) return;
      context.goNamed(
        Pages.forYouOrganisationConfirm.name,
        extra: widget.flowContext
            .copyWith(selectedOrganisation: collectGroup)
            .copyWith(
              entryMediumId: mediumId,
              restrictToEntryQrGoal: restrictToEntryQrGoal,
            )
            .toMap(),
      );
    } on Exception {
      if (!mounted) return;
      await _handleDiscoveryFailure(
        const ForYouDiscoveryResult.failure(ForYouDiscoveryFailure.notFound),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleDiscoveryFailure(
    ForYouDiscoveryResult resolved,
  ) async {
    final failure = resolved.failure ?? ForYouDiscoveryFailure.notFound;

    switch (failure) {
      case ForYouDiscoveryFailure.inactiveQrCode:
        final collectGroup = resolved.collectGroup;
        if (collectGroup == null || collectGroup.nameSpace.isEmpty) {
          await ForYouQrDiscoveryDialogs.showNotFoundDialog(context);
          if (!mounted) return;
          _goToForYouList();
          return;
        }
        final choice = await ForYouQrDiscoveryDialogs.showInactiveQrDialog(
          context,
          organisationName: collectGroup.orgName,
          organisationIcon: CollectGroupType.getIconByType(collectGroup.type),
        );
        if (!mounted) return;
        if (choice ?? false) {
          context.goNamed(
            Pages.forYouOrganisationConfirm.name,
            extra: widget.flowContext
                .forGiveViaListAfterInactiveQr(collectGroup)
                .toMap(),
          );
        } else {
          _goToForYouList();
        }
      case ForYouDiscoveryFailure.inactiveCollectGroup:
        await ForYouQrDiscoveryDialogs.showInactiveCollectGroupDialog(context);
        if (!mounted) return;
        _goToForYouList();
      case ForYouDiscoveryFailure.notFound:
        await ForYouQrDiscoveryDialogs.showNotFoundDialog(context);
        if (!mounted) return;
        _goToForYouList();
    }
  }

  /// Checks if the given barcodes contain a Givt QR code.
  /// Returns the encoded medium id if it is a Givt QR code,
  /// otherwise null.
  String? isGivtQRCode(List<Barcode> barcodes) {
    for (final barcode in barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue == null) continue;

      final uri = Uri.tryParse(rawValue);
      if (uri == null) continue;

      final encodedMediumId = uri.queryParameters['code'];
      if (encodedMediumId == null) continue;

      return encodedMediumId;
    }

    return null;
  }
}
