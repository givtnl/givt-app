import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/give/pages/home_page_view.dart';
import 'package:givt_app/features/give/pages/home_page_with_qr_code.dart';
import 'package:givt_app/features/give/utils/mandate_popup_dismissal_tracker.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/app_update.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.initialAmount,
    required this.code,
    required this.afterGivingRedirection,
    required this.navigateTo,
    required this.given,
    required this.retry,
    super.key,
  });

  final double? initialAmount;
  final String code;
  final String navigateTo;
  final String afterGivingRedirection;
  final bool given;
  final bool retry;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int pageIndex = 0;
  final _key = GlobalKey<ScaffoldState>();
  final AppConfig _appConfig = getIt();
  final MandatePopupDismissalTracker _mandatePopupDismissalTracker =
      MandatePopupDismissalTracker(getIt());

  String? _lastProcessedCode;
  bool _isAppInBackground = false;
  int _scanCounter =
      0; // Counter to force new bloc creation when rescanning same code

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InfraCubit>().checkForUpdate();

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (!mounted) return;

        final auth = context.read<AuthCubit>().state;
        if (message != null && auth.status == AuthStatus.authenticated) {
          NotificationService.instance.navigateFirebaseNotification(message);
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _isAppInBackground = true;
      LoggingInfo.instance.info('HomePage: App went to background');
    } else if (state == AppLifecycleState.resumed && _isAppInBackground) {
      _isAppInBackground = false;
      LoggingInfo.instance.info('HomePage: App resumed from background');

      // If we have a QR code when resuming from background, we should trigger a new scan
      // ONLY if it's a different code or if we previously cleared _lastProcessedCode
      // This prevents double modals when resuming with the same code already showing a modal
      if (widget.code.isNotEmpty && widget.code != _lastProcessedCode) {
        LoggingInfo.instance.info(
          'HomePage: New QR code detected after resume (code: ${widget.code}, last: $_lastProcessedCode), incrementing counter',
        );
        // Wait a bit for the widget to update with new code from route
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _lastProcessedCode = null;
              _scanCounter++; // Increment counter to force new BlocProvider
            });
            LoggingInfo.instance.info(
              'HomePage: Counter incremented to $_scanCounter for code ${widget.code}',
            );
          }
        });
      } else if (widget.code.isNotEmpty) {
        LoggingInfo.instance.info(
          'HomePage: App resumed with same code ${widget.code}, NOT incrementing counter to avoid double modal',
        );
      }
    }
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only increment counter if code actually changed AND we're not coming from background
    // (background case is handled by didChangeAppLifecycleState)
    if (widget.code.isNotEmpty &&
        widget.code != oldWidget.code &&
        !_isAppInBackground) {
      LoggingInfo.instance.info(
        'HomePage: QR code changed from "${oldWidget.code}" to "${widget.code}", triggering new scan',
      );
      _lastProcessedCode = widget.code;
      _scanCounter++; // Increment counter to force new BlocProvider

      // We need to trigger the scan on the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // The BlocProvider in the body will handle creating a new GiveBloc
        // and triggering the scan, so we just need to trigger a rebuild
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    getIt<NotificationService>()
      ..scheduleMonthlySummaryNotification(
        body: locals.budgetPushMonthly,
        title: locals.budgetPushMonthlyBold,
      )
      ..scheduleYearlySummaryNotification(
        body: locals.budgetPushYearlyNearlyEnd,
        title: locals.budgetPushYearlyNearlyEndBold(DateTime.now().year),
      );

    final auth = context.watch<AuthCubit>().state;

    if (widget.navigateTo.isNotEmpty &&
        auth.status == AuthStatus.authenticated) {
      LoggingInfo.instance.info('Navigating to ${widget.navigateTo}');
      final routeName = Pages.values.firstWhere(
        (element) => element.path == widget.navigateTo,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(routeName.name);
      });
    }

    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        key: const ValueKey('EU-Home-AppBar'),
        title: switch (pageIndex) {
          0 => locals.amount,
          1 => locals.chooseGroup,
          _ => locals.give,
        },
        leading: badges.Badge(
          showBadge: auth.user.needRegistration || !auth.user.mandateSigned,
          position: badges.BadgePosition.topStart(
            top: 10,
            start: 30,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              semanticLabel: 'homeMenu',
            ),
            onPressed: () => _key.currentState?.openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.givtPurple,
              builder: (_) => const FAQBottomSheet(),
            ),
            icon: const Icon(
              semanticLabel: 'homeQuestionMark',
              Icons.question_mark_outlined,
              size: 26,
            ),
          ),
          Visibility(
            // ignore: avoid_redundant_argument_values
            visible: kDebugMode,
            child: IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (!context.mounted) {
                  return;
                }
                var prefsStrings = '';
                prefs.getKeys().forEach((element) {
                  prefsStrings += '$element: ${prefs.get(element)}\n';
                });
                final apiUrl = getIt<RequestHelper>().apiURL;
                await showDialog<void>(
                  context: context,
                  builder: (_) => WarningDialog(
                    title: 'Debug Panel',
                    content:
                        'API Url: $apiUrl\n$auth\n Shared Preferences: \n$prefsStrings',
                    onConfirm: () => context.pop(),
                  ),
                );
              },
              icon: const Icon(
                semanticLabel: 'homeAdminPanel',
                Icons.admin_panel_settings,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: widget.code.isNotEmpty
          ? BlocProvider(
              key: ValueKey(
                'qr-bloc-${widget.code}-$_scanCounter-${auth.status}',
              ), // Use counter and status for unique key
              create: (_) {
                final bloc = GiveBloc(
                  getIt(),
                  getIt(),
                  getIt(),
                  getIt(),
                );
                // Trigger QR code scan when code is present and user is authenticated
                if (auth.status == AuthStatus.authenticated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    LoggingInfo.instance.info(
                      'HomePage: Creating new BlocProvider for code ${widget.code} (counter: $_scanCounter, status: ${auth.status})',
                    );
                    // Mark this code as processed
                    _lastProcessedCode = widget.code;

                    bloc.add(
                      GiveQRCodeScannedOutOfApp(
                        widget.code,
                        widget.afterGivingRedirection,
                        auth.user.guid,
                        amount: widget.initialAmount?.toString() ?? '',
                      ),
                    );
                  });
                } else {
                  LoggingInfo.instance.info(
                    'HomePage: BlocProvider created but waiting for authentication (status: ${auth.status})',
                  );
                }
                return bloc;
              },
              child: BlocListener<GiveBloc, GiveState>(
                listener: (context, state) {
                  // Reset last processed code when state goes back to initial
                  // This allows scanning the same QR code again after canceling
                  if (state.status == GiveStatus.initial) {
                    // Don't increment counter here - we only want to increment
                    // when app resumes from background with same code
                    _lastProcessedCode = null;
                    LoggingInfo.instance.info(
                      'HomePage: GiveBloc reset to initial, clearing last processed code',
                    );
                  }
                },
                child: HomePageWithQRCode(
                  initialAmount: widget.initialAmount,
                  given: widget.given,
                  retry: widget.retry,
                  code: widget.code,
                  afterGivingRedirection: widget.afterGivingRedirection,
                  onPageChanged: (index) => setState(
                    () {
                      pageIndex = index;
                    },
                  ),
                  auth: auth,
                  mandatePopupDismissalTracker: _mandatePopupDismissalTracker,
                ),
              ),
            )
          : MultiBlocListener(
              listeners: [
                BlocListener<
                  RemoteDataSourceSyncBloc,
                  RemoteDataSourceSyncState
                >(
                  listener: (context, state) {
                    // Debug information
                    if (state is RemoteDataSourceSyncSuccess && kDebugMode) {
                      var syncString = 'Synced successfully';
                      if (widget.code.isNotEmpty) {
                        syncString += ' with mediumId/code ${widget.code}';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            syncString,
                          ),
                        ),
                      );
                    }

                    // Needs registration dialog
                    if (state is RemoteDataSourceSyncSuccess) {
                      if (!auth.user.needRegistration &&
                          auth.user.mandateSigned) {
                        return;
                      }

                      // TODO: Not show over biometrics
                      NeedsRegistrationDialog.show(
                        context,
                        mandatePopupDismissalTracker:
                            _mandatePopupDismissalTracker,
                      );
                    }
                  },
                ),
                BlocListener<InfraCubit, InfraState>(
                  listener: (context, state) {
                    if (state is InfraUpdateAvailable) {
                      _displayUpdateDialog(
                        context,
                        state.appUpdate,
                      );
                    }
                  },
                ),
              ],
              child: SafeArea(
                child: HomePageView(
                  initialAmount: widget.initialAmount,
                  given: widget.given,
                  retry: widget.retry,
                  code: widget.code,
                  afterGivingRedirection: widget.afterGivingRedirection,
                  onPageChanged: (index) => setState(
                    () {
                      pageIndex = index;
                    },
                  ),
                ),
              ),
            ),
    );
  }

  void _displayUpdateDialog(BuildContext context, AppUpdate appUpdate) {
    final locals = context.l10n;
    var title = locals.updateAlertTitle;
    var content = locals.updateAlertMessage;
    if (appUpdate.critical) {
      title = locals.criticalUpdateTitle;
      content = locals.criticalUpdateMessage;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: !appUpdate.critical,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                final packageName = _appConfig.packageInfo.packageName;
                final url = Platform.isAndroid
                    ? 'market://details?id=$packageName'
                    : 'https://apps.apple.com/app/id$packageName';

                await launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                LoggingInfo.instance.error(e.toString());
              }
            },
            child: Text(
              locals.buttonContinue,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
