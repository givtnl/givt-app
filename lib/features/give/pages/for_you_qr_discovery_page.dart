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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cameraCubit.checkCameraPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _restartScannerIfMounted() async {
    if (!mounted || _isStartingScanner) {
      return;
    }
    _isStartingScanner = true;
    try {
      await _controller.start();
    } finally {
      _isStartingScanner = false;
    }
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
            MobileScanner(
              controller: _controller,
              errorBuilder: (context, error) => ScannerErrorWidget(error: error),
              onDetect: (capture) => _processBarcode(barcodeCapture: capture),
            ),
            const Positioned.fill(child: QrCodeTarget()),
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
        await _handleDiscoveryFailure(
          resolved,
          mediumId: mediumId,
        );
        return;
      }

      final collectGroup = resolved.collectGroup!;
      final qrCode = resolved.qrCode!;
      final restrictToEntryQrGoal = qrCode.name.trim().isNotEmpty;

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
        mediumId: '',
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleDiscoveryFailure(
    ForYouDiscoveryResult resolved, {
    required String mediumId,
  }) async {
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
                .copyWith(selectedOrganisation: collectGroup)
                .copyWith(
                  entryMediumId: mediumId,
                  restrictToEntryQrGoal: false,
                )
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
