import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/create/pages/organisation_search_page.dart';
import 'package:givt_app/features/external_donations/create/repositories/external_donation_create_repository.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_organisation_search_content.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/give/widgets/filter_suggestion_card.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/user_ext.dart';
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

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasSessionStream() => _sessionController.stream;

  void dispose() {
    _sessionController.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeExternalDonationCreateRepository
    with ExternalDonationCreateRepository {
  final ExternalDonationCreateDraft _draft =
      const ExternalDonationCreateDraft();

  @override
  ExternalDonationCreateDraft getDraft() => _draft;

  @override
  void resetDraft() {}

  @override
  void selectKnownOrganisation(CollectGroup organisation) {}

  @override
  void selectCustomOrganisation(String name) {}

  @override
  void updateAmount(String amount) {}

  @override
  void updateTaxDeductible(bool value) {}

  @override
  void selectOneOff() {}

  @override
  void selectRecurring(ExternalDonationFrequency frequency) {}

  @override
  void updateDateMade(DateTime date) {}

  @override
  void updateSeriesStartDate(DateTime date) {}

  @override
  Future<ExternalDonation?> submit() async => null;

  @override
  Future<void> ensureOrganisationsLoaded() async {}
}

class _TestAuthCubit extends AuthCubit {
  _TestAuthCubit(super.repository);

  void setAuthenticatedUser(UserExt user) {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }
}

void main() {
  const userGuid = 'external-donation-search-user';
  const alphaNamespace = 'alphaorg89abcd';
  const betaNamespace = 'betaorgx89abcd';

  const alpha = CollectGroup(
    nameSpace: alphaNamespace,
    orgName: 'Alpha Church',
    hasCelebration: false,
    type: CollectGroupType.church,
  );
  const beta = CollectGroup(
    nameSpace: betaNamespace,
    orgName: 'Beta Charity',
    hasCelebration: false,
    type: CollectGroupType.charities,
  );

  OrganisationBloc? organisationBloc;
  _TestAuthCubit? authCubit;
  _FakeAuthRepository? authRepository;

  Future<void> initBloc() async {
    final prefs = await SharedPreferences.getInstance();
    organisationBloc =
        OrganisationBloc(
          _FakeCollectGroupRepository(const [alpha, beta]),
          _FakeCampaignRepository(),
          prefs,
        )..add(
          OrganisationFetch(
            Country.nl,
            showLastDonated: false,
            type: CollectGroupType.none.index,
          ),
        );
    await organisationBloc!.stream.firstWhere(
      (state) => state.status == OrganisationStatus.filtered,
    );
  }

  Future<void> pumpContent(WidgetTester tester) async {
    await initBloc();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 800,
            child: ExternalDonationOrganisationSearchContent(
              bloc: organisationBloc!,
              onOrganisationSelected: (_) {},
              onCustomNameSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
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
      '${Util.favoritedOrganisationsKey}$userGuid': <String>[alphaNamespace],
    });
  });

  tearDown(() async {
    await organisationBloc?.close();
    await authCubit?.close();
    authRepository?.dispose();
    if (getIt.isRegistered<OrganisationBloc>()) {
      await getIt.unregister<OrganisationBloc>();
    }
  });

  testWidgets('uses the modern search hint and filter pills', (tester) async {
    await pumpContent(tester);

    expect(find.text('Search organisations'), findsOneWidget);
    expect(find.byType(FunOrganisationFilterTilesBar), findsOneWidget);
    expect(find.byType(FilterSuggestionCard), findsNothing);
  });

  testWidgets(
    'shows a filled heart for favourites and keeps list order when toggling',
    (tester) async {
      await pumpContent(tester);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      final orderBefore = organisationBloc!.state.filteredOrganisations
          .map((organisation) => organisation.nameSpace)
          .toList();

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(
        organisationBloc!.state.favoritedOrganisations,
        containsAll([alphaNamespace, betaNamespace]),
      );
      expect(
        organisationBloc!.state.filteredOrganisations
            .map((organisation) => organisation.nameSpace)
            .toList(),
        orderBefore,
      );
    },
  );

  testWidgets('custom organisation row has no heart', (tester) async {
    await pumpContent(tester);

    await tester.enterText(find.byType(TextField), 'zzzznotanorg');
    await tester.pumpAndSettle();

    final addTile = find.widgetWithText(ListTile, 'Add "zzzznotanorg"');
    expect(addTile, findsOneWidget);
    expect(
      find.descendant(of: addTile, matching: find.byType(IconButton)),
      findsNothing,
    );
  });

  testWidgets('page title is Search organisations', (tester) async {
    await initBloc();
    authRepository = _FakeAuthRepository();
    authCubit = _TestAuthCubit(authRepository!)
      ..setAuthenticatedUser(
        const UserExt(
          email: 'test@example.com',
          guid: userGuid,
          amountLimit: 100,
          country: 'NL',
        ),
      );
    getIt.registerSingleton<OrganisationBloc>(organisationBloc!);
    final cubit = ExternalDonationCreateCubit(
      _FakeExternalDonationCreateRepository(),
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit!,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OrganisationSearchPage(cubit: cubit),
        ),
      ),
    );
    await tester.pump();

    final appBar = tester.widget<FunTopAppBar>(find.byType(FunTopAppBar));
    expect(appBar.title, 'Search organisations');

    await tester.pumpAndSettle();
  });
}
