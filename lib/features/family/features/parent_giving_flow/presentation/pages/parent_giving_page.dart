import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/give_cubit.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
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
  bool browserClosing = false;
  final give = getIt<GiveCubit>();

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
        setState(() {
          browserClosing = true;
        });
        await _closeBrowser();
      },
    );
  }

  Future<void> _closeBrowser() async {
    try {
      if (_customInAppBrowser.isOpened()) {
        LoggingInfo.instance.info(
          'Browser is opened, closing browser and navigating to home page',
        );
        await _customInAppBrowser.close();
      }
      if (!mounted) {
        return;
      }

      give.reset();

      unawaited(
        context.read<ImpactGroupsCubit>().fetchImpactGroups(),
      );

      context.pop(true);
    } catch (e) {
      setState(() {
        browserClosing = false;
      });
    }
  }

  Map<String, dynamic> _buildGivt(
    BuildContext context,
  ) {
    final user = context.read<FamilyAuthCubit>().user;
    if (give.state is! GiveFromBrowser) {
      LoggingInfo.instance.error(
        'Invalid state type in parent giving flow. Expected GiveFromBrowser, got ${give.state.runtimeType}',
      );
      throw StateError('Invalid giving state');
    }

    final state = give.state as GiveFromBrowser;

    final orgName = state.orgName;
    return WebViewInput(
      currency: r'$',
      apiUrl: Uri.https(getIt<RequestHelper>().apiURL).toString(),
      guid: user!.guid,
      organisation: orgName,
      givtObj: GivtTransaction.toJsonList([state.givtTransactionObject]),
      confirmBtn: context.l10n.next,
      cancel: context.l10n.cancel,
      areYouSureToCancelGivts: context.l10n.areYouSureToCancelGivts,
      message: context.l10n.safariGivtTransaction,
      thanks: context.l10n.givtIsBeingProcessed(
        orgName,
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
              url: WebUri.uri(
                Uri.https(
                  getIt<RequestHelper>().apiURL,
                  'confirm-G4F.html',
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
              ),
              webViewSettings: InAppWebViewSettings(
                underPageBackgroundColor: Colors.white,
              ),
            ),
          );

          /// In case the user ends up on the giving screen
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Visibility(
                visible: !browserClosing,
                child: ElevatedButton(
                  child: const Text('Go Back Home'),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom InAppBrowser class with custom callback
typedef CustomInAppBrowserCallback = void Function(Uri? url);

class CustomInAppBrowser extends InAppBrowser {
  CustomInAppBrowser({
    required this.onLoad,
  }) : super();

  final CustomInAppBrowserCallback onLoad;

  @override
  Future<void> onLoadStart(Uri? url) async => onLoad(url);
}
