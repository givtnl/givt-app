import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/cubit/give_result_cubit.dart';
import 'package:givt_app/features/give/cubit/give_result_uimodel.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/widgets/give_result_views.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
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
  late GiveResultCubit _resultCubit;
  bool browserIsOpened = false;
  bool showBackButton = false;
  bool _isCheckingResult = false;

  @override
  void initState() {
    super.initState();
    _resultCubit = getIt<GiveResultCubit>();
    _customInAppBrowser = CustomInAppBrowser(
      onLoad: (url) async {
        if (url == null) {
          return;
        }
        if (!url.toString().contains('natived')) {
          return;
        }
        LoggingInfo.instance.info(
          'Closing confirm browser from $url',
        );
        await _closeBrowser();
      },
      onExitCallback: _onBrowserExited,
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

  @override
  void dispose() {
    unawaited(_resultCubit.close());
    super.dispose();
  }

  Future<void> _onBrowserExited() async {
    if (_isCheckingResult) {
      return;
    }
    _isCheckingResult = true;
    if (!mounted) {
      return;
    }
    LoggingInfo.instance.info(
      'Confirm browser closed, fetching transaction status',
    );
    final transactionIds = context.read<GiveBloc>().state.transactionIds;
    await _resultCubit.checkStatus(transactionIds);
  }

  Future<void> _closeBrowser() async {
    if (_customInAppBrowser.isOpened()) {
      LoggingInfo.instance.info(
        'Browser is opened, closing browser',
      );
      await _customInAppBrowser.close();
    }
  }

  Future<void> _goHome({required bool given}) async {
    if (!mounted) {
      return;
    }

    final afterGivingRedirection = context
        .read<GiveBloc>()
        .state
        .afterGivingRedirection;

    context.goNamed(
      Pages.home.name,
      queryParameters: {
        'given': given.toString(),
      },
    );

    if (given && afterGivingRedirection.isNotEmpty) {
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
    final country = Country.fromCode(user.country);
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
      givtObj: GivtTransaction.toWebJsonList(giveBlocState.givtTransactions),
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
      isForYouFlow: giveBlocState.isForYouFlow,
      shouldShowCreditCard: country.isCreditCard,
    ).toJson();
  }

  String _confirmPagePath(BuildContext context) {
    final country = Country.fromCode(
      context.read<AuthCubit>().state.user.country,
    );
    return country.isCreditCard ? 'confirm-G4F.html' : 'confirm.html';
  }

  void _openBrowser(BuildContext context) {
    if (browserIsOpened) {
      return;
    }
    final givt = _buildGivt(context);
    final confirmPath = _confirmPagePath(context);

    Vibration.vibrate(amplitude: 128);
    LoggingInfo.instance.info(
      'Opening browser at $confirmPath with $givt',
    );

    browserIsOpened = true;
    _customInAppBrowser.openUrlRequest(
      urlRequest: URLRequest(
        url: WebUri.uri(
          Uri.https(
            getIt<RequestHelper>().apiURL,
            confirmPath,
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
        ),
      ),
    );
  }

  Widget _browserPlaceholder(BuildContext context) {
    _openBrowser(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseStateConsumer(
        cubit: _resultCubit,
        onInitial: _browserPlaceholder,
        onLoading: (_) => const GiveResultLoadingView(),
        onData: (context, uiModel) {
          switch (uiModel.outcome) {
            case GiveResultOutcome.success:
              return GiveResultSuccessView(
                onDone: () => _goHome(given: true),
              );
            case GiveResultOutcome.failed:
              return GiveResultFailedView(
                onGoHome: () => _goHome(given: false),
              );
            case GiveResultOutcome.unknown:
              return GiveResultUnknownView(
                onGoHome: () => _goHome(given: false),
              );
          }
        },
      ),
    );
  }
}

/// Custom InAppBrowser class with custom callback
typedef CustomInAppBroserCallback = void Function(Uri? url);
typedef CustomInAppBrowserExitCallback = Future<void> Function();

class CustomInAppBrowser extends InAppBrowser {
  CustomInAppBrowser({
    required this.onLoad,
    required this.onExitCallback,
  }) : super();

  final CustomInAppBroserCallback onLoad;
  final CustomInAppBrowserExitCallback onExitCallback;

  @override
  Future<void> onLoadStart(Uri? url) async => onLoad(url);

  @override
  Future<void> onCloseWindow() async {
    LoggingInfo.instance.info('User has pressed the back button');
  }

  @override
  void onExit() {
    unawaited(onExitCallback());
  }
}
