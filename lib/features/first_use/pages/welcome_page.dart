import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/auth/pages/email_signup_page.dart';
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
    final locale = Platform.localeName;
    final locals = AppLocalizations.of(context);

    final imageNames = [
      'givy_welcome',
      'givy_register',
      'firstuse_select',
      'firstuse_orgs',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: size.height * 0.04,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildCarouselSlider(size, imageNames, locals, locale),
              Expanded(child: Container()),
              _buildAnimatedBottomIndexes(imageNames, size, context),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  EmailSignupPage.route(),
                ),
                child: Text(
                  locals.welcomeContinue,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (BuildContext context) => const LoginPage(),
                ),
                child: _buildAlreadyAnAccountLogin(context, locals),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildAlreadyAnAccountLogin(
    BuildContext context,
    AppLocalizations locals,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleSmall,
        children: [
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
          height: size.height * 0.65,
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
        Column(
          children: [
            SizedBox(
              height: size.height * 0.04,
            ),
            _buildTitleAndSubtitle(
              title: title,
              subtitle: isFirst ? locals.firstUseWelcomeSubTitle : '',
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Image.asset(
              'assets/images/${isFirst && locale.contains('nl') ? '${path}_${locale.split('_')[0]}' : path}.png',
              fit: BoxFit.cover,
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isFirst ? FontWeight.w300 : FontWeight.bold,
              ),
        )
      ],
    );
  }
}
