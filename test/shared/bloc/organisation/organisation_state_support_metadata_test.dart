import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';

void main() {
  late AppLocalizations locals;

  setUp(() {
    locals = lookupAppLocalizations(const Locale('en'));
  });

  group('OrganisationState.buildSupportMetadata', () {
    test('includes search text and church filter when chip is active', () {
      final state = OrganisationState(
        previousSearchQuery: 'kwf',
        selectedType: CollectGroupType.church.index,
      );

      expect(
        state.buildSupportMetadata(locals),
        {
          'searchText': 'kwf',
          'categoryFilterActive': 'true',
          'categoryFilter': 'Church',
        },
      );
    });

    test('omits searchText and reports no filter for none.index', () {
      final state = OrganisationState(
        selectedType: CollectGroupType.none.index,
      );

      expect(
        state.buildSupportMetadata(locals),
        {
          'categoryFilterActive': 'false',
          'categoryFilter': 'None',
        },
      );
    });

    test(
      'omits searchText and reports no filter for default selectedType -1',
      () {
        const state = OrganisationState();

        expect(
          state.buildSupportMetadata(locals),
          {
            'categoryFilterActive': 'false',
            'categoryFilter': 'None',
          },
        );
      },
    );

    test('maps charities to Charity', () {
      final state = OrganisationState(
        previousSearchQuery: 'kwf',
        selectedType: CollectGroupType.charities.index,
      );

      expect(
        state.buildSupportMetadata(locals),
        {
          'searchText': 'kwf',
          'categoryFilterActive': 'true',
          'categoryFilter': 'Charity',
        },
      );
    });

    test('maps campaign to Campaign', () {
      final state = OrganisationState(
        selectedType: CollectGroupType.campaign.index,
      );

      expect(
        state.buildSupportMetadata(locals)['categoryFilter'],
        'Campaign',
      );
      expect(
        state.buildSupportMetadata(locals)['categoryFilterActive'],
        'true',
      );
    });

    test('maps artists to Other', () {
      final state = OrganisationState(
        selectedType: CollectGroupType.artists.index,
      );

      expect(
        state.buildSupportMetadata(locals)['categoryFilter'],
        'Other',
      );
      expect(
        state.buildSupportMetadata(locals)['categoryFilterActive'],
        'true',
      );
    });
  });
}
