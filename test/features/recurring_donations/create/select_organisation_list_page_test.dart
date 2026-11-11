import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step1_select_organization_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/select_organisation_list_page.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_repository.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/actions/fun_button.dart';
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
    unawaited(_sessionController.close());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNetworkInfo with NetworkInfo {
  @override
  bool get isConnected => true;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
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
  const userGuid = 'recurring-step1-user';
  const redCross = CollectGroup(
    nameSpace: '0123456789abcd',
    orgName: 'Red Cross',
    hasCelebration: false,
    type: CollectGroupType.church,
  );

  late OrganisationBloc organisationBloc;
  late Step1SelectOrganizationCubit stepCubit;
  late _TestAuthCubit authCubit;
  late _FakeAuthRepository authRepository;

  Future<void> initBloc() async {
    final prefs = await SharedPreferences.getInstance();
    organisationBloc =
        OrganisationBloc(
          _FakeCollectGroupRepository(const [redCross]),
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
      (state) => state.status == OrganisationStatus.filtered,
    );
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

    authRepository = _FakeAuthRepository();
    authCubit = _TestAuthCubit(authRepository)
      ..setAuthenticatedUser(
        const UserExt(
          email: 'test@example.com',
          guid: userGuid,
          amountLimit: 100,
          country: 'NL',
        ),
      );
  });

  tearDown(() async {
    await organisationBloc.close();
    await stepCubit.close();
    await authCubit.close();
    authRepository.dispose();
    await getIt.reset();
  });

  testWidgets('Select carries the chosen organisation name', (tester) async {
    // This bloc handler does not resume under the widget-test clock once the
    // page library is loaded. Real async lets the filtered state arrive.
    await tester.runAsync(initBloc);
    final prefs = await SharedPreferences.getInstance();
    stepCubit = Step1SelectOrganizationCubit(
      RecurringDonationRepository(
        _FakeCollectGroupRepository(const [redCross]),
        APIService(
          RequestHelper(
            _FakeNetworkInfo(),
            prefs,
            apiURL: 'example.test',
          ),
        ),
      ),
    );
    await getIt.reset();
    getIt
      ..registerSingleton<AppConfig>(AppConfig())
      ..registerSingleton<OrganisationBloc>(organisationBloc)
      ..registerSingleton<Step1SelectOrganizationCubit>(stepCubit);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SelectOrganisationListPage(
            onCollectGroupSelected: _noop,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(
      () => organisationBloc.stream.firstWhere(
        (state) => state.status == OrganisationStatus.filtered,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Red Cross'));
    await tester.pump();

    final button = tester.widget<FunButton>(
      find.widgetWithText(FunButton, 'Select'),
    );
    expect(
      button.analyticsEvent.name,
      AnalyticsEventName.recurringStep1SelectOrganisationContinueClicked,
    );
    expect(button.analyticsEvent.parameters['organization'], 'Red Cross');
  });
}

void _noop(CollectGroup _) {}
