import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/give/widgets/for_you.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/features/give/models/organisation.dart';

class FakeNetworkInfo with NetworkInfo {
  FakeNetworkInfo({required this.isConnected});

  @override
  final bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasInternetConnectionStream() => _controller.stream.distinct();

  void emitConnected() {
    _controller.add(true);
  }
}

class FakeOrganisationGoalsRepository with OrganisationGoalsRepository {
  @override
  Future<OrganisationGoalsSummary> fetchGoalsSummary(
    String collectGroupId,
  ) async =>
      const OrganisationGoalsSummary.empty();

  @override
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId) async =>
      const OrganisationGoalsResponse();

  @override
  void clearCache() {}
}

class FakeCollectGroupRepository with CollectGroupRepository {
  FakeCollectGroupRepository(this._groups);

  final List<CollectGroup> _groups;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => _groups;

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => _groups;
}

class FakeCampaignRepository with CampaignRepository {
  @override
  Future<Organisation> getOrganisation(String mediumId) async =>
      const Organisation.empty();

  @override
  Future<bool> saveLastDonation(Organisation organisation) async => true;

  @override
  Future<Organisation> getLastOrganisationDonated() async =>
      const Organisation.empty();

  @override
  Future<Organisation> getCachedOrganisation(String mediumId) async =>
      const Organisation.empty();
}

void main() {
  setUp(() async {
    try {
      getIt.reset();
    } catch (_) {}
    SharedPreferences.setMockInitialValues({});

    getIt.registerLazySingleton<OrganisationGoalsRepository>(
      () => FakeOrganisationGoalsRepository(),
    );
    getIt.registerLazySingleton<NetworkInfo>(
      () => FakeNetworkInfo(isConnected: true),
    );
  });

  Future<OrganisationBloc> _createOrganisationBloc() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return OrganisationBloc(
      FakeCollectGroupRepository(const []),
      FakeCampaignRepository(),
      sharedPrefs,
    );
  }

  Widget _appUnderTest({
    required OrganisationBloc organisationBloc,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp.router(
      locale: locale,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider.value(
              value: organisationBloc,
              child: const ForYou(),
            ),
          ),
          GoRoute(
            path: '/by-location',
            name: Pages.forYouByLocation.name,
            builder: (_, __) => const Text('BY_LOCATION'),
          ),
          GoRoute(
            path: '/by-qr',
            name: Pages.forYouByQrCode.name,
            builder: (_, __) => const Text('BY_QR'),
          ),
          GoRoute(
            path: '/by-beacon',
            name: Pages.forYouByBeacon.name,
            builder: (_, __) => const Text('BY_BEACON'),
          ),
        ],
      ),
    );
  }

  testWidgets(
    'tapping location tile navigates to for-you discovery location route',
    (tester) async {
      final organisationBloc = await _createOrganisationBloc();
      final testWidget = _appUnderTest(organisationBloc: organisationBloc);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Location'));
      await tester.pumpAndSettle();

      expect(find.text('BY_LOCATION'), findsOneWidget);
    },
  );

  testWidgets(
    'empty state shows updated Dutch favorites title',
    (tester) async {
      final organisationBloc = await _createOrganisationBloc();
      final testWidget = _appUnderTest(
        organisationBloc: organisationBloc,
        locale: const Locale('nl'),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Je favorieten altijd bij de hand'), findsWidgets);
    },
  );

  testWidgets(
    'tapping QR tile navigates to for-you discovery QR route',
    (tester) async {
      final organisationBloc = await _createOrganisationBloc();
      final testWidget = _appUnderTest(organisationBloc: organisationBloc);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.text('QR code'));
      await tester.pumpAndSettle();

      expect(find.text('BY_QR'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping beacon tile navigates to for-you discovery beacon route',
    (tester) async {
      final organisationBloc = await _createOrganisationBloc();
      final testWidget = _appUnderTest(organisationBloc: organisationBloc);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // The beacon tile is the 3rd one in a horizontally scrollable row and
      // is partially visible by default. Drag until it can be tapped.
      final horizontalScroll = find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView && widget.scrollDirection == Axis.horizontal,
      );
      expect(horizontalScroll, findsOneWidget);

      await tester.drag(horizontalScroll, const Offset(-500, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Collection device'));
      await tester.pumpAndSettle();

      expect(find.text('BY_BEACON'), findsOneWidget);
    },
  );
}

