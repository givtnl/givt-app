import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/l10n/l10n.dart';

class AppVersion extends StatelessWidget {
  AppVersion({
    super.key,
  });

  final AppConfig _appConfig = getIt();

  @override
  Widget build(BuildContext context) {
    final packageInfo = _appConfig.packageInfo;
    return Text(
      '''${context.l10n.appVersion} ${packageInfo.version}.${packageInfo.buildNumber}''',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 15,
          ),
    );
  }
}
