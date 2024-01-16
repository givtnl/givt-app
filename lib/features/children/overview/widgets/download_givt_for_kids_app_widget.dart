import 'dart:developer';
import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadGivtForKidsAppWidget extends StatefulWidget {
  const DownloadGivtForKidsAppWidget({super.key});

  @override
  State<DownloadGivtForKidsAppWidget> createState() =>
      _DownloadGivtForKidsAppWidgetState();
}

class _DownloadGivtForKidsAppWidgetState
    extends State<DownloadGivtForKidsAppWidget> {
  var _isGivt4KidsAppInstalled = true;

  @override
  void initState() {
    _initialise();
    super.initState();
  }

  Future<void> _initialise() async {
    final isAppInstalled = await _checkIfGivt4KidsAppInstalled();

    setState(() {
      _isGivt4KidsAppInstalled = isAppInstalled;
    });
  }

  Future<bool> _checkIfGivt4KidsAppInstalled() async {
    try {
      final String appUrl;
      if (Platform.isIOS) {
        appUrl = 'appscheme://net.givtapp.kids';
      } else if (Platform.isAndroid) {
        final currentAppInfo = await PackageInfo.fromPlatform();
        if (currentAppInfo.packageName.contains('.test')) {
          appUrl = 'net.givtapp.kids.test';
        } else {
          appUrl = 'net.givtapp.kids';
        }
      } else {
        return false;
      }

      final kidsApp = await AppCheck.checkAvailability(appUrl);
      if (kidsApp != null) {
        log('${kidsApp.packageName} is installed on the device.');
        return true;
      }
    } on PlatformException {
      log('Givt4Kids app is not installed on the device.');
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _isGivt4KidsAppInstalled
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              final appId =
                  Platform.isAndroid ? 'net.givtapp.kids' : '1658797002';
              final url = Uri.parse(
                Platform.isAndroid
                    ? 'market://details?id=$appId'
                    : 'https://apps.apple.com/app/id$appId',
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: AppTheme.givtBlue,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: SvgPicture.asset(
                      'assets/images/givt4kids_logo.svg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.downloadG4KBannerTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.downloadG4KBannerText,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
