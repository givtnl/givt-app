import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/email_signup_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    required this.prefs,
    super.key,
  });
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return WelcomePageView(
      prefs: prefs,
    );
  }
}

class WelcomePageView extends StatefulWidget {
  const WelcomePageView({
    required this.prefs,
    super.key,
  });
  final SharedPreferences prefs;
  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = Platform.localeName;
    final locals = AppLocalizations.of(context);

    final imageNames = [
      'givy_welcome',
      'givy_register',
      'firstuse_select',
      'firstuse_orgs',
    ];

    return FunScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 30,
        ),
      ),
      minimumPadding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
      body: Column(
        children: [
          Expanded(
            child: _buildCarouselSlider(
              size,
              imageNames,
              locals,
              locale,
            ),
          ),
          _buildAnimatedBottomIndexes(imageNames, size, context),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
            child: FunButton(
              onTap: () async {
                if (!getIt<NetworkInfo>().isConnected) {
                  if (!context.mounted) {
                    return;
                  }
                  await showDialog<void>(
                    context: context,
                    builder: (_) => WarningDialog(
                      title: locals.noInternetConnectionTitle,
                      content: locals.noInternet,
                    ),
                  );
                  return;
                }
                if (!context.mounted) {
                  return;
                }
                // Without biometrics we use the regular route to login
                if (!await LocalAuthInfo.instance.canCheckBiometrics) {
                  if (!context.mounted) {
                    return;
                  }
                  await Navigator.of(context).push(EmailSignupPage.route());
                  return;
                }

                final hasAuthenticated =
                    await LocalAuthInfo.instance.authenticate();

                // When not authenticated we go to the regular route
                if (!hasAuthenticated) {
                  if (!context.mounted) {
                    return;
                  }

                  await Navigator.of(context).push(EmailSignupPage.route());
                  return;
                }

                // When authenticated we go to the home route
                if (!context.mounted) {
                  return;
                }
                await context.read<AuthCubit>().authenticate();
                if (!context.mounted) {
                  return;
                }

                context.goNamed(Pages.home.name);
              },
              text: locals.welcomeContinue,
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.welcomeContinueClicked,
              ),
            ),
          ),
        ],
      ),
    );
  }

  CarouselSlider _buildCarouselSlider(
    Size size,
    List<String> imageNames,
    AppLocalizations locals,
    String locale,
  ) =>
      CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: size.height * 0.5,
          viewportFraction: 1,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: _buildCarouselItems(imageNames, size, locals, locale),
      );

  Row _buildAnimatedBottomIndexes(
    List<String> imageNames,
    Size size,
    BuildContext context,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imageNames.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: size.width * 0.05,
              height: size.height * 0.01,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(
                  _current == entry.key ? 0.9 : 0.4,
                ),
              ),
            ),
          );
        }).toList(),
      );

  List<Widget> _buildCarouselItems(
    List<String> imageNames,
    Size size,
    AppLocalizations locals,
    String locale,
  ) {
    // ignore: prefer_final_locals
    var carouselItems = <Widget>[];
    imageNames.asMap().forEach((int index, String path) {
      final isFirst = index == 0;
      var title = locals.firstUseWelcomeTitle;
      if (index == 1) {
        title = locals.firstUseLabelTitle1;
      }
      if (index == 2) {
        title = locals.firstUseLabelTitle2;
      }
      if (index == 3) {
        title = locals.firstUseLabelTitle3;
      }

      carouselItems.add(
        Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: 80,
              child: _buildTitleAndSubtitle(
                title: title,
                subtitle: isFirst ? locals.firstUseWelcomeSubTitle : '',
              ),
            ),
            Image.asset(
              'assets/images/${isFirst && locale.contains('nl') ? '${path}_${locale.split('_')[0]}' : path}.png',
              fit: BoxFit.cover,
              height: size.height * 0.3,
            ),
            Container(),
          ],
        ),
      );
    });
    return carouselItems;
  }

  Widget _buildTitleAndSubtitle({
    required String title,
    String subtitle = '',
  }) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: Column(
        children: [
          TitleMediumText(
            title,
            textAlign: TextAlign.center,
          ),
          BodyMediumText(
            subtitle,
          ),
        ],
      ),
    );
  }
}
