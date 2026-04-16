import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/pages/for_you_list_page.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCollectGroupRepository with CollectGroupRepository {
  _FakeCollectGroupRepository(this._groups);

  final List<CollectGroup> _groups;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => _groups;

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => _groups;
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
  const userGuid = 'tutorial-test-user-guid';

  const testCollectGroup = CollectGroup(
    nameSpace: '0123456789abcd',
    orgName: 'Test church',
    hasCelebration: false,
    type: CollectGroupType.church,
  );

  Future<OrganisationBloc> createBloc({
    required SharedPreferences prefs,
    List<String> initialFavorites = const [],
  }) async {
    const key = '${Util.favoritedOrganisationsKey}$userGuid';
    await prefs.setStringList(key, initialFavorites);
    final bloc = OrganisationBloc(
      _FakeCollectGroupRepository([testCollectGroup]),
      _FakeCampaignRepository(),
      prefs,
    )..add(
        OrganisationFetch(
          Country.nl,
          showLastDonated: false,
          type: CollectGroupType.none.index,
        ),
      );
    await bloc.stream.firstWhere(
      (s) => s.status == OrganisationStatus.filtered,
    );
    return bloc;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      Session.tag: jsonEncode({
        'GUID': userGuid,
        'Email': 'test@example.com',
        'access_token': 'access',
        'refresh_token': 'refresh',
        '.expires': '2099-01-01T00:00:00Z',
        'isLoggedIn': true,
      }),
    });
  });

  testWidgets('shows favorites tutorial modal when user has no favorites',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final bloc = await createBloc(prefs: prefs);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: bloc,
          child: const ForYouListPage(
            flowContext: ForYouFlowContext(source: ForYouEntrySource.emptyState),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Save your'), findsOneWidget);
    expect(find.textContaining('Tap the heart'), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);
  });

  testWidgets('does not show favorites tutorial when user has favorites',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final bloc = await createBloc(
      prefs: prefs,
      initialFavorites: [testCollectGroup.nameSpace],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: bloc,
          child: const ForYouListPage(
            flowContext: ForYouFlowContext(source: ForYouEntrySource.emptyState),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Save your'), findsNothing);
  });
}
