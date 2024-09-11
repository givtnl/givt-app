import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// This file does not exist yet,
// it will be generated in the next step
import 'main.directories.g.dart';

void main() {
  GetIt.instance.registerLazySingleton(() => AppConfig());

  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // The [directories] variable does not exist yet,
      // it will be generated in the next step
      directories: directories,
      addons: [
        // LocalizationAddon(
        //   locales: AppLocalizations.supportedLocales,
        //   localizationsDelegates: AppLocalizations.localizationsDelegates,
        //   initialLocale: AppLocalizations.supportedLocales.last,
        // ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone13,
          ],
          initialDevice: Devices.ios.iPhoneSE,
        ),
        AlignmentAddon(
          initialAlignment: Alignment.center,
        ),
      ],
    );
  }
}
