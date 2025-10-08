import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class GivingPage extends StatefulWidget {
  const GivingPage({
    super.key,
  });
  @override
  State<GivingPage> createState() => _GivingPageState();
}

class _GivingPageState extends State<GivingPage> {
  late CustomInAppBrowser _customInAppBrowser;
  bool browserIsOpened = false;
  bool showBackButton = false;

  @override
  void initState() {
    super.initState();
    _customInAppBrowser = CustomInAppBrowser(
      onLoad: (url) async {
        if (url == null) {
          return;
        }
        if (!url.toString().contains('natived')) {
          return;
        }
        LoggingInfo.instance.info(
          'Closing browser and navigating to home page from $url',
        );
        await _closeBrowser();
      },
    );
    
    // Show the back button after 1 second delay
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showBackButton = true;
        });
      }
    });
  }

  Future<void> _closeBrowser() async {
    if (_customInAppBrowser.isOpened()) {
      LoggingInfo.instance.info(
        'Browser is opened, closing browser and navigating to home page',
      );
      await _customInAppBrowser.close();
    }
    if (!mounted) {
      return;
    }

    final afterGivingRedirection =
        context.read<GiveBloc>().state.afterGivingRedirection;

    context.goNamed(
      Pages.home.name,
      queryParameters: {
        'given': 'true',
      },
    );

    if (afterGivingRedirection.isNotEmpty) {
      final url = Uri.parse(afterGivingRedirection);
      LoggingInfo.instance.info(
        'Redirecting after external link donation. Attempting to launch $url',
      );
      if (!await launchUrl(url)) {
        LoggingInfo.instance.error('Could not launch $url');
        throw Exception('Could not launch $url');
      }
    }
  }

  Map<String, dynamic> _buildGivt(
    BuildContext context,
  ) {
    final giveBlocState = context.read<GiveBloc>().state;
    final user = context.read<AuthCubit>().state.user;
    final format = NumberFormat.simpleCurrency(
      name: giveBlocState.organisation.currency,
    );
    var orgName = giveBlocState.organisation.organisationName!;
    final instanceName = giveBlocState.instanceName;
    if (giveBlocState.instanceName.isNotEmpty && instanceName != orgName) {
      orgName = '$orgName: $instanceName';
    }
    return WebViewInput(
      currency: format.currencySymbol,
      apiUrl: Uri.https(getIt<RequestHelper>().apiURL).toString(),
      guid: user.guid,
      organisation: orgName,
      collectGroupId: giveBlocState.organisation.collectGroupId,
      givtObj: GivtTransaction.toJsonList(giveBlocState.givtTransactions),
      confirmBtn: context.l10n.next,
      cancel: context.l10n.cancel,
      areYouSureToCancelGivts: context.l10n.areYouSureToCancelGivts,
      message: context.l10n.safariGivtTransaction,
      thanks: context.l10n.givtIsBeingProcessed(
        giveBlocState.organisation.organisationName.toString(),
      ),
      yesSuccess: context.l10n.yesSuccess,
      close: context.l10n.close,
      collect: context.l10n.collect,
      subtotalText: context.l10n.donationSubtotal,
      totalText: context.l10n.donationTotal,
      platformFeeNoContributionText: context.l10n.platformFeeNoContribution,
      platformFeeGoodOptionText: context.l10n.platformFeeGoodOption,
      platformFeeCommonOptionText: context.l10n.platformFeeCommonOption,
      platformFeeGenerousOptionText: context.l10n.platformFeeGenerousOption,
      platformFeeCustomOptionText: context.l10n.platformFeeCustomOption,
      platformFeeCustomPlaceholder: context.l10n.platformFeeCustomPlaceholder,
      platformFeeText: context.l10n.platformFeeText,
      platformFeeTitle: context.l10n.platformFeeTitle,
      platformFeePlaceholder: context.l10n.platformFeePlaceholder,
      platformFeeRequired: context.l10n.platformFeeRequired,
      platformFeeRemember: context.l10n.platformFeeRemember,
      transactionIds: giveBlocState.transactionIds,
    ).toJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (
          context,
        ) {
          if (browserIsOpened) {
            return const SizedBox.shrink();
          }
          final givt = _buildGivt(context);

          Vibration.vibrate(amplitude: 128);
          LoggingInfo.instance.info(
            'Opening browser with $givt',
          );

          browserIsOpened = true;
          _customInAppBrowser.openUrlRequest(
            urlRequest: URLRequest(
              url: WebUri.uri(
                Uri.https(
                  getIt<RequestHelper>().apiURL,
                  'confirm.html',
                  {'msg': base64.encode(utf8.encode(jsonEncode(givt)))},
                ),
              ),
            ),
            settings: InAppBrowserClassSettings(
              browserSettings: InAppBrowserSettings(
                hideCloseButton: true,
                hideUrlBar: true,
                hideTitleBar: true,
                hideToolbarBottom: true,
                hideToolbarTop: true,
                toolbarTopBackgroundColor: Colors.white,
                toolbarTopTintColor: Colors.white,
                toolbarBottomBackgroundColor: Colors.white,
                allowGoBackWithBackButton: false,
                shouldCloseOnBackButtonPressed: false,
                closeOnCannotGoBack: false,
              ),
              webViewSettings: InAppWebViewSettings(
                underPageBackgroundColor: Colors.white,
                allowsBackForwardNavigationGestures: false,
              )
            ),
          );

          /// In case the user ends up on the giving screen
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: showBackButton
                  ? ElevatedButton(
                      child: const Text('Go Back Home'),
                      onPressed: () {
                        context.goNamed(
                          Pages.home.name,
                          queryParameters: {
                            'given': 'true',
                          },
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}

/// Custom InAppBrowser class with custom callback
typedef CustomInAppBroserCallback = void Function(Uri? url);

class CustomInAppBrowser extends InAppBrowser {
  CustomInAppBrowser({
    required this.onLoad,
  }) : super();

  final CustomInAppBroserCallback onLoad;

  @override
  Future<void> onLoadStart(Uri? url) async => onLoad(url);

  @override
  Future<void> onCloseWindow() async {
    LoggingInfo.instance.info('User has pressed the back button');
  }
}
