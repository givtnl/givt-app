import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class GivingPage extends StatefulWidget {
  const GivingPage({super.key});

  @override
  State<GivingPage> createState() => _GivingPageState();
}

class _GivingPageState extends State<GivingPage> {
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
        await LoggingInfo.instance.info(
          'Closing browser and navigating to home page from $url',
        );
        await _closeBrowser();
      },
    );
  }

  Future<void> _closeBrowser() async {
    if (_customInAppBrowser.isOpened()) {
      await LoggingInfo.instance.info(
        'Browser is opened, closing browser and navigating to home page',
      );
      await _customInAppBrowser.close();
    }
    if (!mounted) {
      return;
    }
    context.goNamed(
      Pages.home.name,
      queryParameters: {
        'given': 'true',
      },
    );
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
    if (giveBlocState.instanceName.isNotEmpty) {
      orgName = '$orgName: ${giveBlocState.instanceName}';
    }
    return WebViewInput(
      currency: format.currencySymbol,
      apiUrl: Uri.https(getIt<APIService>().apiURL).toString(),
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
                getIt<APIService>().apiURL,
                'confirm.html',
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
          return const SizedBox.shrink();
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
