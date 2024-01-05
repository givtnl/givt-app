import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AddMemeberSuccessPage extends StatelessWidget {
  const AddMemeberSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '${context.l10n.congratulationsKey}\n',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              children: [
                TextSpan(
                  text: '${context.l10n.downloadKey} ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: '${context.l10n.g4kKey} ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: context.l10n.childrenCanExperienceTheJoyOfGiving,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/vpc_success.svg',
            width: size.width * 0.8,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid
                          ? 'net.givtapp.kids'
                          : '1658797002';
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
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      SizedBox(width: 32),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(Pages.childrenOverview.name);
                },
                child: Text(context.l10n.iWillDoThisLater,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
