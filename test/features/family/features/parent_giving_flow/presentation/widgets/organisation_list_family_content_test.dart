import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_list_family_content.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/infra_repository.dart';
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

class _FakeInfraRepository with InfraRepository {
  @override
  Future<bool> contactSupport({
    required String guid,
    required String message,
    String? subject,
  }) async =>
      true;

  @override
  Future<AppUpdate?> checkAppUpdate({
    required String buildNumber,
    required String platform,
  }) async =>
      null;
}

void main() {
  const userGuid = 'report-missing-test-user-guid';

  const testCollectGroup = CollectGroup(
    nameSpace: '0123456789abcd',
    orgName: 'Test church',
    hasCelebration: false,
    type: CollectGroupType.church,
  );

  late OrganisationBloc organisationBloc;
  late AuthCubit authCubit;
  late InfraCubit infraCubit;

  Future<void> initBloc({List<CollectGroup> groups = const []}) async {
    final prefs = await SharedPreferences.getInstance();
    organisationBloc = OrganisationBloc(
      _FakeCollectGroupRepository(groups),
      _FakeCampaignRepository(),
      prefs,
    )..add(
        OrganisationFetch(
          Country.nl,
          showLastDonated: false,
          type: CollectGroupType.none.index,
        ),
      );
    await organisationBloc.stream.firstWhere(
      (s) => s.status == OrganisationStatus.filtered,
    );
  }

  Future<void> pumpContent(
    WidgetTester tester, {
    required bool showReportMissingOption,
    List<CollectGroup> groups = const [testCollectGroup],
  }) async {
    await initBloc(groups: groups);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<InfraCubit>.value(value: infraCubit),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: OrganisationListFamilyContent(
                bloc: organisationBloc,
                onTapListItem: (_) {},
                removedCollectGroupTypes: const [],
                showReportMissingOption: showReportMissingOption,
              ),
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
      '${Util.favoritedOrganisationsKey}$userGuid': <String>[],
    });

    authCubit = AuthCubit(_FakeAuthRepository());
    infraCubit = InfraCubit(_FakeInfraRepository(), AppConfig());
  });

  tearDown(() async {
    await organisationBloc.close();
    await authCubit.close();
    await infraCubit.close();
  });

  testWidgets(
    'shows report missing organisation tile when showReportMissingOption is true',
    (tester) async {
      await pumpContent(tester, showReportMissingOption: true);

      expect(
        find.byKey(const ValueKey('reportMissingOrganisationTile')),
        findsOneWidget,
      );
      expect(
        find.text('Report a missing organisation'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'hides report missing organisation tile when showReportMissingOption is false',
    (tester) async {
      await pumpContent(tester, showReportMissingOption: false);

      expect(
        find.byKey(const ValueKey('reportMissingOrganisationTile')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'opens AboutGivtBottomSheet with prefilled text when tile is tapped',
    (tester) async {
      await pumpContent(
        tester,
        showReportMissingOption: true,
        groups: const [],
      );

      await tester.tap(
        find.byKey(const ValueKey('reportMissingOrganisationTile')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      tester.takeException();

      expect(
        find.text('Hi! I would really like to give to:'),
        findsOneWidget,
      );
    },
  );
}
