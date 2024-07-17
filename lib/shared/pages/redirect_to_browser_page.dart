import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/shared/pages/loading_page.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectToBrowserPage extends StatelessWidget {
  const RedirectToBrowserPage({required this.uri, super.key});

  final String uri;

  @override
  Widget build(BuildContext context) {
    launchUrl(Uri.parse(uri)).then((value) {
      context.goNamed(Pages.splash.name);
    });
    return const LoadingPage();
  }
}
