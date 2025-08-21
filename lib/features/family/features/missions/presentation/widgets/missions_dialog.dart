import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showMissionNotAvailableDialog(BuildContext context) async {
  await FunModal(
    closeAction: () => Navigator.of(context).pop(),
    title: 'Update Required!',
    subtitle:
        'This mission is available in the latest version. Update now to continue the adventure!',
    icon: FunAvatar.captain(),
    buttons: [
      FunButton(
        text: 'Update now!',
        onTap: () async {
          await launchStoreUrl();
          Navigator.of(context).pop();
        },
        analyticsEvent: AmplitudeEvents.updateNowClicked.toEvent(),
      ),
    ],
  ).show(context);
}

Future<void> launchStoreUrl() async {
  const iosUrl = 'https://apps.apple.com/nl/app/givt/id1181435988';
  const androidUrl =
      'https://play.google.com/store/apps/details?id=net.givtapp.droid2&hl=us';

  final url = Platform.isIOS ? Uri.parse(iosUrl) : Uri.parse(androidUrl);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    // do nothing, we're probably on a weird platform/ simulator
  }
}
