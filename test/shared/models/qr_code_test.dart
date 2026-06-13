import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/qr_code.dart';

void main() {
  group('QrCode.isGeneric', () {
    test('fromJson sets isGeneric true when name is empty', () {
      final qrCode = QrCode.fromJson(const {
        'N': '',
        'I': 'abc.def',
        'A': true,
      });

      expect(qrCode.isGeneric, isTrue);
    });

    test('fromJson sets isGeneric false when name is present', () {
      final qrCode = QrCode.fromJson(const {
        'N': 'Building fund',
        'I': 'abc.def',
        'A': true,
      });

      expect(qrCode.isGeneric, isFalse);
    });

    test('fromJson sets isGeneric true when name is whitespace only', () {
      final qrCode = QrCode.fromJson(const {
        'N': '   ',
        'I': 'abc.def',
        'A': true,
      });

      expect(qrCode.isGeneric, isTrue);
    });

    test('toJson/fromJson roundtrip preserves raw name and derives isGeneric',
        () {
      final qrCode = QrCode.fromJson(const {
        'N': '',
        'I': 'abc.def',
        'A': true,
      });

      final roundTripped = QrCode.fromJson(qrCode.toJson());

      expect(roundTripped.name, equals(''));
      expect(roundTripped.isGeneric, isTrue);
    });

    test('CollectGroup JSON roundtrip preserves raw QR name and isGeneric', () {
      final group = CollectGroup.fromJson({
        'NS': 'abc',
        'N': 'Org A',
        'C': false,
        'T': CollectGroupType.church.index,
        'A': true,
        'Q': [
          const {
            'N': '',
            'I': 'def',
            'A': true,
          },
        ],
      });

      final roundTripped = CollectGroup.fromJson(group.toJson());
      final qrCode = roundTripped.qrCodes.first;
      expect(qrCode.name, equals(''));
      expect(qrCode.isGeneric, isTrue);
    });

    test('CollectGroup.fromJson keeps raw QR name for generic codes', () {
      final group = CollectGroup.fromJson({
        'NS': 'abc',
        'N': 'Org A',
        'C': false,
        'T': CollectGroupType.church.index,
        'A': true,
        'Q': [
          const {
            'N': '',
            'I': 'def',
            'A': true,
          },
        ],
      });

      expect(group.qrCodes, hasLength(1));
      final qrCode = group.qrCodes.first;
      expect(qrCode.name, equals(''));
      expect(qrCode.isGeneric, isTrue);
    });
  });
}
