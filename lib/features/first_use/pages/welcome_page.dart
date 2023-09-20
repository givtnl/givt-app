import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/email_signup_page.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({required this.prefs, super.key});
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return WelcomePageView(
      prefs: prefs,
    );
  }
}

class WelcomePageView extends StatefulWidget {
  const WelcomePageView({required this.prefs, super.key});
  final SharedPreferences prefs;
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
    final auth = context.read<AuthCubit>().state;

    final imageNames = [
      'givy_welcome',
      'givy_register',
      'firstuse_select',
      'firstuse_orgs',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.transparent,
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 30,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(EmailSignupPage.route()),
                  onLongPress: hackUSASIM,
                  child: Text(
                    locals.welcomeContinue,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (!await LocalAuthInfo.instance.canCheckBiometrics) {
                    if (!mounted) {
                      return;
                    }
                    await showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => LoginPage(
                        email: auth.user.email,
                      ),
                    );
                    return;
                  }
                  final hasAuthenticated =
                      await LocalAuthInfo.instance.authenticate();
                  if (!hasAuthenticated) {
                    if (!mounted) {
                      return;
                    }
                    await showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => LoginPage(
                        email: auth.user.email,
                      ),
                    );
                    return;
                  }
                  if (!mounted) {
                    return;
                  }
                  await context.read<AuthCubit>().authenticate();
                  if (!mounted) {
                    return;
                  }
                  context.goNamed(Pages.home.name);
                },
                child: _buildAlreadyAnAccountLogin(context, locals),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyAnAccountLogin(
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
              height: 75,
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

  Future<void> hackUSASIM() async {
    const apiURL = String.fromEnvironment('API_URL_US');
    if (!apiURL.contains('dev')) {
      return;
    }
    if (widget.prefs.getString('countryIso') == Country.us.countryCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hack removed'),
        ),
      );
      await widget.prefs.remove('countryIso');
      const baseUrl = String.fromEnvironment('API_URL_EU');
      const baseUrlAWS = String.fromEnvironment('API_URL_AWS_EU');
      get_it.getIt<APIService>().updateApiUrl(baseUrl, baseUrlAWS);

      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App hacked for USA'),
      ),
    );

    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');
    get_it.getIt<APIService>().updateApiUrl(baseUrl, baseUrlAWS);
    await widget.prefs.setString('countryIso', Country.us.countryCode);
  }
}
