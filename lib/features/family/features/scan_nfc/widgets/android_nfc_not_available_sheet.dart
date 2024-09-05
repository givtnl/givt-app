import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:go_router/go_router.dart';

class NfcNotAvailableSheet extends StatelessWidget {
  const NfcNotAvailableSheet({
    required this.scanNfcCubit,
    super.key,
  });
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const TitleSmallText(
          "Oh wait, we can't scan the coin",
          textAlign: TextAlign.center,
        ),
        Container(
          // hardcoded size from design file
          height: 160,
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: SvgPicture.asset(
            'assets/family/images/not_found_phone.svg',
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
          ),
        ),
        Text(
          'Could you turn on NFC so we are\nable to find it?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FunButton(
            onTap: () {
              cancelScanning(context);
              AppSettings.openAppSettings(type: AppSettingsType.nfc);
            },
            text: 'Go to Settings',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: FunButton.secondary(
            onTap: () => cancelScanning(context),
            text: 'Cancel',
            amplitudeEvent: AmplitudeEvents.cancelClicked,
          ),
        ),
      ],
    );
  }

  void cancelScanning(BuildContext context) {
    context.pop();
    scanNfcCubit.cancelScanning();
  }
}
