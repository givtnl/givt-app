import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/give/widgets/for_you.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userGuid = 'user-guid-1';
const _namespace = 'test-org-0001';
const _orgName = 'Riverside Test Church';

const _church = CollectGroup(
  nameSpace: _namespace,
  orgName: _orgName,
  hasCelebration: false,
  type: CollectGroupType.church,
);

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeApiService extends APIService {
  _FakeApiService(RequestHelper requestHelper) : super(requestHelper);

  @override
  Future<FeaturedCollectGroup?> getFeaturedDoorToDoorCollectGroup() async =>
      null;
}

class _RecordingGoalsRepository with OrganisationGoalsRepository {
  _RecordingGoalsRepository(this.summary);

  OrganisationGoalsSummary summary;
  final calls = <({String collectGroupId, bool forceRefresh})>[];

  @override
  Future<OrganisationGoalsSummary> fetchGoalsSummary(
    String collectGroupId, {
    bool forceRefresh = false,
  }) async {
    calls.add((collectGroupId: collectGroupId, forceRefresh: forceRefresh));
    return summary;
  }

  @override
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId) async =>
      const OrganisationGoalsResponse();

  @override
  void clearCache() {}
}

class _FakeCollectGroupRepository with CollectGroupRepository {
  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => const [_church];

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => const [_church];
}

class _FakeCampaignRepository with CampaignRepository {
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
  late _RecordingGoalsRepository goalsRepository;
  late _FakeNetworkInfo networkInfo;

  setUp(() async {
    await getIt.reset();

    SharedPreferences.setMockInitialValues({
      Session.tag: jsonEncode({
        'GUID': _userGuid,
        'Email': 'test@example.com',
        'access_token': 'access',
        'refresh_token': 'refresh',
        '.expires': '2099-01-01T00:00:00Z',
        'isLoggedIn': true,
      }),
      '${Util.favoritedOrganisationsKey}$_userGuid': <String>[_namespace],
    });

    goalsRepository = _RecordingGoalsRepository(
      const OrganisationGoalsSummary(allocationsCount: 2, qrCodesCount: 0),
    );
    networkInfo = _FakeNetworkInfo(isConnected: true);
    getIt
      ..registerLazySingleton<OrganisationGoalsRepository>(
        () => goalsRepository,
      )
      ..registerLazySingleton<NetworkInfo>(() => networkInfo);
    final preferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<APIService>(
      () => _FakeApiService(
        RequestHelper(
          networkInfo,
          preferences,
          apiURL: 'api.example.com',
        ),
      ),
    );
  });

  Future<GoRouter> pumpHome(WidgetTester tester) async {
    final preferences = await SharedPreferences.getInstance();
    final organisationBloc = OrganisationBloc(
      _FakeCollectGroupRepository(),
      _FakeCampaignRepository(),
      preferences,
    );
    final router = GoRouter(
      initialLocation: Pages.home.path,
      routes: [
        GoRoute(
          path: Pages.home.path,
          builder: (context, state) => BlocProvider.value(
            value: organisationBloc,
            child: const Scaffold(body: ForYou()),
          ),
          routes: [
            GoRoute(
              path: 'child',
              builder: (context, state) => const Text('CHILD'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    organisationBloc.add(
      OrganisationFetch(
        Country.nl,
        type: CollectGroupType.none.index,
        showLastDonated: false,
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('shows the fetched collection goal count', (tester) async {
    await pumpHome(tester);

    expect(find.text('2 Collection Goals'), findsWidgets);
    expect(find.text('3 Collection Goals'), findsNothing);
    expect(goalsRepository.calls, [
      (collectGroupId: _namespace, forceRefresh: true),
    ]);
  });

  testWidgets('omits the collection goal line when the count is zero', (
    tester,
  ) async {
    goalsRepository.summary = const OrganisationGoalsSummary(
      allocationsCount: 0,
      qrCodesCount: 0,
    );

    await pumpHome(tester);

    expect(find.text(_orgName), findsWidgets);
    expect(find.textContaining('Collection Goal'), findsNothing);
  });

  testWidgets('refetches when the home route is shown again', (tester) async {
    final router = await pumpHome(tester);
    final callsAfterOpen = goalsRepository.calls.length;

    router.go('/home/child');
    await tester.pumpAndSettle();
    expect(find.text('CHILD'), findsOneWidget);
    expect(goalsRepository.calls, hasLength(callsAfterOpen));

    router.go(Pages.home.path);
    await tester.pumpAndSettle();

    expect(goalsRepository.calls, hasLength(callsAfterOpen + 1));
    expect(goalsRepository.calls.last.forceRefresh, isTrue);
    expect(goalsRepository.calls.last.collectGroupId, _namespace);
  });

  testWidgets('does not guess a count while offline', (tester) async {
    networkInfo.isConnected = false;

    await pumpHome(tester);

    expect(find.text(_orgName), findsWidgets);
    expect(goalsRepository.calls, isEmpty);
    expect(find.text('3 Collection Goals'), findsNothing);
  });
}
