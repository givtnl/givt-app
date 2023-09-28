import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/app_theme.dart';
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
  bool useFingerprint = false;

  @override
  void initState() {
    LocalAuthInfo.instance.canCheckBiometrics.then((value) {
      setState(() {
        useFingerprint = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        widget.isFingerprint
            ? Platform.isAndroid
                ? locals.fingerprintTitle
                : locals.touchId
            : locals.faceId,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.isFingerprint
                ? Platform.isAndroid
                    ? locals.fingerprintUsage
                    : locals.touchIdUsage
                : locals.faceIdUsage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.isFingerprint
                      ? Platform.isAndroid
                          ? locals.fingerprintTitle
                          : locals.touchId
                      : locals.faceId,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Switch.adaptive(
                activeColor: AppTheme.givtLightGreen,
                onChanged: (bool value) async {
                  try {
                    final hasAuthentication =
                        await LocalAuthInfo.instance.authenticate();
                    if (!hasAuthentication) {
                      return;
                    }
                    await LocalAuthInfo.instance.setCanCheckBiometrics(
                      value: value,
                    );
                    setState(() {
                      useFingerprint = value;
                    });
                  } catch (e) {
                    await LoggingInfo.instance.error(
                      e.toString(),
                      methodName: StackTrace.current.toString(),
                    );
                    if (!mounted) {
                      return;
                    }
                    await showDialog<void>(
                      context: context,
                      builder: (_) => WarningDialog(
                        title: locals.errorOccurred,
                        content: locals.errorContactGivt,
                        onConfirm: () => context.pop(),
                      ),
                    );
                  }
                },
                value: useFingerprint,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
