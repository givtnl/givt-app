import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/donation_overview/models/donation_organisation_name_resolver.dart';
import 'package:givt_app/shared/models/collect_group.dart';

CollectGroup _group({
  required String nameSpace,
  required String orgName,
}) {
  return CollectGroup(
    nameSpace: nameSpace,
    orgName: orgName,
    hasCelebration: false,
    type: CollectGroupType.church,
  );
}

void main() {
  group('DonationOrganisationNameResolver', () {
    test('keeps an existing organisation name', () {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 5,
        'timestamp': '2026-03-15T10:00:00',
        'organisationName': 'Hartstichting',
        'mediumId': 'ns1.c1',
      });

      final filled = DonationOrganisationNameResolver.fillMissingNames(
        [donation],
        [_group(nameSpace: 'ns1', orgName: 'Wrong Org')],
      );

      expect(filled.single.organisationName, 'Hartstichting');
    });

    test('resolves a blank name from the medium namespace', () {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 5,
        'timestamp': '2026-03-15T10:00:00',
        'organisationName': '',
        'mediumId': '61f7ed0155530623d000.c00000000001',
        'collectId': 1,
      });

      final filled = DonationOrganisationNameResolver.fillMissingNames(
        [donation],
        [
          _group(
            nameSpace: '61f7ed0155530623d000',
            orgName: 'Achterlandkerk',
          ),
        ],
      );

      expect(filled.single.organisationName, 'Achterlandkerk');
    });

    test('does not overwrite external donation names', () {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'external',
        'id': 'tx-1',
        'amount': 20,
        'timestamp': '2026-03-10T09:00:00',
        'organisationName': '',
        'mediumId': 'ns1.c1',
      });

      final filled = DonationOrganisationNameResolver.fillMissingNames(
        [donation],
        [_group(nameSpace: 'ns1', orgName: 'Should Not Apply')],
      );

      expect(filled.single.organisationName, isEmpty);
      expect(filled.single.isExternal, isTrue);
    });

    test('leaves the name empty when no collect group matches', () {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 5,
        'timestamp': '2026-03-15T10:00:00',
        'organisationName': '',
        'mediumId': 'unknown.c1',
      });

      final filled = DonationOrganisationNameResolver.fillMissingNames(
        [donation],
        [_group(nameSpace: 'ns1', orgName: 'Local Church')],
      );

      expect(filled.single.organisationName, isEmpty);
    });

    test('trims whitespace-only names before looking up', () {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 5,
        'timestamp': '2026-03-15T10:00:00',
        'organisationName': '   ',
        'mediumId': 'ns-church.beacon',
      });

      final filled = DonationOrganisationNameResolver.fillMissingNames(
        [donation],
        [_group(nameSpace: 'ns-church', orgName: 'Local Church')],
      );

      expect(filled.single.organisationName, 'Local Church');
    });
  });
}
