import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

class FakeCollectGroupRepository implements CollectGroupRepository {
  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => [];

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => [];
}

class FakeCampaignRepository implements CampaignRepository {
  @override
  Future<bool> saveLastDonation(Organisation organisation) async => true;

  @override
  Future<Organisation> getOrganisation(String mediumId) async =>
      const Organisation.empty();

  @override
  Future<Organisation> getLastOrganisationDonated() async =>
      const Organisation.empty();

  @override
  Future<Organisation> getCachedOrganisation(String mediumId) async =>
      const Organisation.empty();
}

void main() {
  const userGuid = 'user-123';

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

  test('favorites changes refresh across OrganisationBloc instances', () async {
    final sharedPrefs = await SharedPreferences.getInstance();

    final blocA = OrganisationBloc(
      FakeCollectGroupRepository(),
      FakeCampaignRepository(),
      sharedPrefs,
    );

    final blocB = OrganisationBloc(
      FakeCollectGroupRepository(),
      FakeCampaignRepository(),
      sharedPrefs,
    );

    const namespace = 'NLtest-namespace';

    Future<void> waitForBlocB() async {
      final alreadyUpdated =
          blocB.state.favoritedOrganisations.contains(namespace);
      if (alreadyUpdated) return;

      final completer = Completer<void>();
      late final StreamSubscription<OrganisationState> subscription;
      subscription = blocB.stream.listen((_) {
        if (blocB.state.favoritedOrganisations.contains(namespace)) {
          completer.complete();
          subscription.cancel();
        }
      });

      await completer.future.timeout(const Duration(seconds: 2));
    }

    try {
      blocA.add(const AddOrganisationToFavorites(namespace));
      await waitForBlocB();

      expect(
        blocB.state.favoritedOrganisations,
        contains(namespace),
      );
    } finally {
      await blocA.close();
      await blocB.close();
    }
  });
}

