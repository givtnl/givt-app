import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/give/widgets/triple_animated_switch.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_recieve_invite_sheet.dart';
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
    required this.code,
    required this.afterGivingRedirection,
    required this.navigateTo,
    required this.given,
    super.key,
  });

  final String code;
  final String navigateTo;
  final String afterGivingRedirection;
  final bool given;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final _key = GlobalKey<ScaffoldState>();
  final AppConfig _appConfig = getIt();
  final _infraCubit = getIt<InfraCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _infraCubit.checkForUpdate();
    });
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
    final impactGroupsState = context.watch<ImpactGroupsCubit>().state;

    if (widget.navigateTo.isNotEmpty &&
        auth.status == AuthStatus.authenticated) {
      LoggingInfo.instance.info('Navigating to ${widget.navigateTo}');
      final routeName = Pages.values
          .firstWhere((element) => element.path == widget.navigateTo);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(routeName.name);
      });
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: switch (pageIndex) {
          0 => Text(locals.amount),
          1 => !auth.user.isUsUser
              ? Text(locals.discoverHomeDiscoverTitle)
              : Text(locals.chooseGroup),
          2 => Text(locals.discoverHomeDiscoverTitle),
          _ => Text(locals.give),
        },
        leading: badges.Badge(
          showBadge: auth.user.needRegistration || !auth.user.mandateSigned,
          position: badges.BadgePosition.topStart(
            top: 10,
            start: 30,
          ),
          child: IconButton(
            icon: const Icon(Icons.menu),
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
                Icons.admin_panel_settings,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RemoteDataSourceSyncBloc, RemoteDataSourceSyncState>(
            listener: (context, state) {
              // Debug information
              if (state is RemoteDataSourceSyncSuccess && kDebugMode) {
                var syncString =
                    'Synced successfully Sim //${getIt<CountryIsoInfo>().countryIso}';
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
                if (!auth.user.needRegistration ||
                    auth.user.mandateSigned ||
                    auth.user.isInvitedUser ||
                    auth.user.isUsUser || // Don't show to US users
                    impactGroupsState.status ==
                        ImpactGroupCubitStatus.invited) {
                  return;
                }
                // TODO: Not show over biometrics
                _buildNeedsRegistrationDialog(context);
              }
            },
          ),
          BlocListener<InfraCubit, InfraState>(
            bloc: _infraCubit,
            listener: (context, state) {
              if (state is InfraUpdateAvailable) {
                _displayUpdateDialog(
                  context,
                  state.appUpdate,
                );
              }
            },
          ),
          BlocListener<ImpactGroupsCubit, ImpactGroupsState>(
            listener: (context, state) {
              if (state.status == ImpactGroupCubitStatus.invited) {
                unawaited(
                  AnalyticsHelper.logEvent(
                    eventName:
                        AmplitudeEvents.invitedToImpactGroupBottomSheetShown,
                  ),
                );

                final impactGroup = state.invitedGroup;
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  useSafeArea: true,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (_) {
                    return ImpactGroupRecieveInviteSheet(
                      invitdImpactGroup: impactGroup,
                    );
                  },
                );
              }
            },
          ),
        ],
        child: SafeArea(
          child: _HomePageView(
            given: widget.given,
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

  Future<void> _buildNeedsRegistrationDialog(
    BuildContext context,
  ) {
    final user = context.read<AuthCubit>().state.user;
    final isUS = user.country == Country.us.countryCode;
    return showDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          isUS ? context.l10n.goodToKnow : context.l10n.importantReminder,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          context.l10n.finalizeRegistrationPopupText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              context.l10n.askMeLater,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 17),
            ),
          ),
          TextButton(
            onPressed: () {
              if (user.needRegistration) {
                final createStripe = user.personalInfoRegistered &&
                    user.country == Country.us.countryCode;
                context
                  ..goNamed(
                    createStripe
                        ? FamilyPages.registrationUS.name
                        : Pages.registration.name,
                    queryParameters: {
                      'email': user.email,
                      'createStripe': createStripe.toString(),
                    },
                  )
                  ..pop();
                return;
              }
              context
                ..goNamed(Pages.sepaMandateExplanation.name)
                ..pop();
            },
            child: Text(
              context.l10n.finalizeRegistration,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ],
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
              locals.continueKey,
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

class _HomePageView extends StatefulWidget {
  const _HomePageView({
    required this.onPageChanged,
    required this.given,
    required this.afterGivingRedirection,
    required this.code,
  });

  final bool given;
  final String code;
  final String afterGivingRedirection;
  final void Function(int) onPageChanged;

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  late PageController pageController;
  int pageIndex = 0;
  bool isPageAnimationActive = false;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        HomePageViewLayout(
          child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              ChooseAmount(
                country: Country.fromCode(auth.user.country),
                amountLimit: auth.user.amountLimit,
                hasGiven: widget.given,
                arePresetsEnabled: auth.presets.isEnabled,
                presets: auth.presets.presets,
                onAmountChanged:
                    (firstCollection, secondCollection, thirdCollection) =>
                        context.goNamed(
                  Pages.selectGivingWay.name,
                  extra: {
                    'firstCollection': firstCollection,
                    'secondCollection': secondCollection,
                    'thirdCollection': thirdCollection,
                    'code': widget.code,
                    'afterGivingRedirection': widget.afterGivingRedirection,
                  },
                ),
              ),
              const ChooseCategory(),
            ],
          ),
        ),
        ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              bottom: 5,
            ),
            child: auth.user.isUsUser
                ? TripleAnimatedSwitch(
                    pageIndex: pageIndex,
                    onChanged: onPageChanged,
                  )
                : AnimatedSwitch(
                    pageIndex: pageIndex,
                    onChanged: onPageChanged,
                  ),
          ),
        ),
      ],
    );
  }

  void onPageChanged(int index) {
    if (index == pageIndex || isPageAnimationActive) {
      return;
    }
    setState(() {
      pageIndex = index;
      widget.onPageChanged(index);
    });
    if (pageIndex == 1 && context.read<AuthCubit>().state.user.isUsUser) {
      context.read<ImpactGroupsCubit>().fetchImpactGroups();
    }

    setState(() {
      isPageAnimationActive = true;
    });

    pageController
        .animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then(
      (_) {
        setState(() {
          isPageAnimationActive = false;
        });
      },
    );
  }
}
