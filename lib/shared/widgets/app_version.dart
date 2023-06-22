
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        final packageInfo = snapshot.data!;
        return Text(
          '''${context.l10n.appVersion} ${packageInfo.version}.${packageInfo.buildNumber}''',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 15,
              ),
        );
      },
    );
  }
}