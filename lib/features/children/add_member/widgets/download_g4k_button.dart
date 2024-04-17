import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadG4KButton extends StatelessWidget {
  const DownloadG4KButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (Platform.isAndroid || Platform.isIOS) {
          final appId = Platform.isAndroid ? 'net.givtapp.kids' : '1658797002';
          final url = Uri.parse(
            Platform.isAndroid
                ? 'market://details?id=$appId'
                : 'https://apps.apple.com/app/id$appId',
          );
          launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/images/givt4kids_logo.svg',
            height: 32,
          ),
          Text(
            context.l10n.downloadG4k,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
