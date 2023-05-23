import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/auth/pages/email_signup.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/l10n/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const WelcomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomePageView();
  }
}

class WelcomePageView extends StatefulWidget {
  const WelcomePageView({super.key});

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = Platform.localeName.contains('nl') ? '' : 'en';
    final locals = AppLocalizations.of(context);

    final imageNames = [
      'givy_welkom',
      'givy_register',
      'firstuse_select',
      'firstuse_orgs',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: size.height * 0.04,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: size.height * 0.7,
                viewportFraction: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: _buildCarouselItems(imageNames, size, locals, locale),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageNames.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: size.width * 0.05,
                    height: size.height * 0.01,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                EmailSignupPage.route(),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(40),
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: Text(locals.welcomeContinue),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(LoginPage.route()),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall,
                  children: <TextSpan>[
                    TextSpan(
                      text: locals.alreadyAnAccount,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: locals.login,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCarouselItems(
    List<String> imageNames,
    Size size,
    AppLocalizations locals,
    String locale,
  ) {
    List<Widget> carouselItems = [];
    imageNames.asMap().forEach((int index, String path) {
      final isFirst = index == 0;
      String title = locals.firstUseWelcomeTitle;
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
        Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            _buildTitleAndSubtitle(
              title: title,
              subtitle: isFirst ? locals.firstUseWelcomeSubTitle : '',
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/images/${isFirst ? '${path}_$locale' : path}.png',
              fit: BoxFit.cover,
              width: size.width * 0.8,
              height: size.height * 0.4,
            ),
          ],
        ),
      );
    });
    return carouselItems;
  }

  Widget _buildTitleAndSubtitle({
    required String title,
    String subtitle = '',
    bool isFirst = true,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: isFirst ? 16 : 24,
            fontWeight: isFirst ? FontWeight.w300 : FontWeight.bold,
          ),
        )
      ],
    );
  }
}
