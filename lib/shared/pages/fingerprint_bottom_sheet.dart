import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class FingerprintBottomSheet extends StatefulWidget {
  const FingerprintBottomSheet({
    required this.isFingerprint,
    super.key,
  });

  final bool isFingerprint;

  @override
  State<FingerprintBottomSheet> createState() => _FingerprintBottomSheetState();
}

class _FingerprintBottomSheetState extends State<FingerprintBottomSheet> {
  bool _initialValue = false;
  bool _currentValue = false;
  bool _hasLoadedInitialValue = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    LocalAuthInfo.instance.canCheckBiometrics.then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _initialValue = value;
        _currentValue = value;
        _hasLoadedInitialValue = true;
      });
    });
  }

  bool get _hasChanges => _currentValue != _initialValue;

  bool get _canInteract => _hasLoadedInitialValue && !_isLoading;

  String _title(AppLocalizations locals) {
    if (widget.isFingerprint) {
      return Platform.isAndroid ? locals.fingerprintTitle : locals.touchId;
    }
    return locals.faceId;
  }

  String _toggleLabel(AppLocalizations locals) {
    if (widget.isFingerprint) {
      return Platform.isAndroid
          ? locals.loginUsingFingerprint
          : locals.loginUsingTouchId;
    }
    return locals.loginUsingFaceId;
  }

  Future<void> _onSave() async {
    if (!_hasChanges || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_currentValue) {
        final hasAuthentication = await LocalAuthInfo.instance.authenticate();
        if (!hasAuthentication) {
          _revertToInitialValue();
          return;
        }
      }

      await LocalAuthInfo.instance.setCanCheckBiometrics(
        value: _currentValue,
      );

      if (_currentValue == false) {
        await BiometricsHelper.deny();
      }

      if (!mounted) {
        return;
      }
      context.pop();
    } on Object catch (e, stackTrace) {
      _revertToInitialValue();
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) => WarningDialog(
          title: context.l10n.errorOccurred,
          content: context.l10n.errorContactGivt,
          onConfirm: () => context.pop(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _revertToInitialValue() {
    if (!mounted || _currentValue == _initialValue) {
      return;
    }
    setState(() => _currentValue = _initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: _title(locals),
      titleColor: FamilyAppTheme.secondary30,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: BodyMediumText(_toggleLabel(locals)),
            ),
            Switch.adaptive(
              value: _currentValue,
              activeTrackColor: FamilyAppTheme.secondary30,
              onChanged: _canInteract
                  ? (value) => setState(() => _currentValue = value)
                  : null,
            ),
          ],
        ),
      ),
      primaryButton: FunButton(
        isDisabled: !_canInteract || !_hasChanges,
        onTap: _canInteract && _hasChanges ? _onSave : null,
        text: _isLoading ? locals.loadingTitle : locals.save,
        analyticsEvent: AnalyticsEvent(
          AnalyticsEventName.biometricSettingsSaveClicked,
          parameters: {
            AnalyticsHelper.toggleStatusKey:
                _currentValue ? 'enabled' : 'disabled',
          },
        ),
      ),
    );
  }
}
