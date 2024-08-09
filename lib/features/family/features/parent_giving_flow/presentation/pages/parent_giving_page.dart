import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class ParentGivingPage extends StatefulWidget {
  const ParentGivingPage({
    super.key,
  });
  @override
  State<ParentGivingPage> createState() => _ParentGivingPageState();
}

class _ParentGivingPageState extends State<ParentGivingPage> {
  late CustomInAppBrowser _customInAppBrowser;
  bool browserIsOpened = false;

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

    unawaited(
      context.read<ImpactGroupsCubit>().fetchImpactGroups(),
    );

    final afterGivingRedirection =
        context.read<GiveBloc>().state.afterGivingRedirection;
    context.pop();

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
              url: Uri.https(
                getIt<RequestHelper>().apiURL,
                'confirm-G4F.html',
                {'msg': base64.encode(utf8.encode(jsonEncode(givt)))},
              ),
            ),
            options: InAppBrowserClassOptions(
              crossPlatform: InAppBrowserOptions(
                toolbarTopBackgroundColor: Colors.white,
              ),
              ios: IOSInAppBrowserOptions(
                toolbarBottomBackgroundColor: Colors.white,
                hideToolbarBottom: true,
              ),
            ),
          );

          /// In case the user ends up on the giving screen
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                child: const Text('Go Back Home'),
                onPressed: () {
                  context.pop();
                },
              ),
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
}
