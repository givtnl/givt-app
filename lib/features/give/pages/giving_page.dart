import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
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

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const GivingPage(),
    );
  }

  @override
  State<GivingPage> createState() => _GivingPageState();
}

class _GivingPageState extends State<GivingPage> {
  late CustomInAppBrowser _customInAppBrowser;

  @override
  void initState() {
    super.initState();
    _customInAppBrowser = CustomInAppBrowser(
      onLoad: (url) {
        if (url == null) {
          return;
        }
        if (!url.toString().contains('natived')) {
          return;
        }
        _closeBrowser();
      },
    );
  }

  Future<void> _closeBrowser() async {
    if (_customInAppBrowser.isOpened()) {
      await _customInAppBrowser.close();
    }
    if (!mounted) {
      return;
    }

    context.go('/home');
  }

  Map<String, dynamic> _buildGivt(
    BuildContext context,
  ) {
    final giveBlocState = context.read<GiveBloc>().state;
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    final format = NumberFormat.simpleCurrency(
      name: giveBlocState.organisation.currency,
    );
    return WebViewInput(
      currency: format.currencySymbol,
      apiUrl: Uri.https(getIt<APIService>().apiURL).toString(),
      guid: user.guid,
      organisation: giveBlocState.organisation.organisationName!,
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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/home'),
        ),
      ),
      body: BlocConsumer<GiveBloc, GiveState>(
        listener: (context, state) {
          if (state.status == GiveStatus.error) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          if (state.status == GiveStatus.loading ||
              state.status == GiveStatus.error) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final givt = _buildGivt(context);

          Vibration.vibrate(amplitude: 128);

          _customInAppBrowser
              .openUrlRequest(
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
                    presentationStyle: IOSUIModalPresentationStyle.POPOVER,
                    hideToolbarBottom: true,
                  ),
                ),
              )
              .whenComplete(
                _closeBrowser,
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
  }) : super(implementation: WebViewImplementation.NATIVE);

  final CustomInAppBroserCallback onLoad;

  @override
  Future<void> onLoadStart(Uri? url) async => onLoad(url);
}
