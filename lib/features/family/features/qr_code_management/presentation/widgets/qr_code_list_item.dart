import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/qr_code.dart';
import 'package:givt_app/utils/utils.dart';

class QrCodeListItem extends StatelessWidget {
  const QrCodeListItem({
    required this.qrCode,
    required this.isMobile,
    required this.onActivate,
    required this.onDeactivate,
    required this.onDownload,
    super.key,
  });

  final QrCode qrCode;
  final bool isMobile;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return FunCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusIndicator(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleMediumText(qrCode.name),
                      const SizedBox(height: 4),
                      BodyMediumText(
                        'ID: ${qrCode.instance}',
                        color: FamilyAppTheme.neutral70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: qrCode.isActive
            ? FamilyAppTheme.secondary95
            : FamilyAppTheme.neutral95,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        qrCode.isActive ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
        size: 16,
        color: qrCode.isActive
            ? FamilyAppTheme.secondary40
            : FamilyAppTheme.neutral70,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isMobile) {
      return _buildMobileActionButtons();
    } else {
      return _buildDesktopActionButtons();
    }
  }

  Widget _buildMobileActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Download button - icon only on mobile
        Expanded(
          child: FunButton(
            onTap: onDownload,
            text: '',
            leftIcon: FontAwesomeIcons.download,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.qrCodeDownloadPressed,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Activate/Deactivate button - icon only on mobile
        Expanded(
          child: qrCode.isActive
              ? FunButton.destructiveSecondary(
                  onTap: onDeactivate,
                  text: '',
                  leftIcon: FontAwesomeIcons.pause,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.qrCodeDeactivatePressed,
                  ),
                )
              : FunButton.secondary(
                  onTap: onActivate,
                  text: '',
                  leftIcon: FontAwesomeIcons.play,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.qrCodeActivatePressed,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDesktopActionButtons() {
    return Row(
      children: [
        // Download button - with text on desktop
        FunButton(
          onTap: onDownload,
          text: 'Download',
          leftIcon: FontAwesomeIcons.download,
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.qrCodeDownloadPressed,
          ),
        ),
        const SizedBox(width: 12),
        // Activate/Deactivate button - with text on desktop
        qrCode.isActive
            ? FunButton.destructiveSecondary(
                onTap: onDeactivate,
                text: 'Deactivate',
                leftIcon: FontAwesomeIcons.pause,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.qrCodeDeactivatePressed,
                ),
              )
            : FunButton.secondary(
                onTap: onActivate,
                text: 'Activate',
                leftIcon: FontAwesomeIcons.play,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.qrCodeActivatePressed,
                ),
              ),
      ],
    );
  }
}