import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';

void main() {
  group('SortCodeTextFormatter', () {
    group('formatForDisplay', () {
      test('returns empty string for empty input', () {
        expect(SortCodeTextFormatter.formatForDisplay(''), '');
      });

      test('formats digits-only as XX-XX-XX', () {
        expect(SortCodeTextFormatter.formatForDisplay('123456'), '12-34-56');
        expect(SortCodeTextFormatter.formatForDisplay('000000'), '00-00-00');
      });

      test('keeps already formatted sort code', () {
        expect(SortCodeTextFormatter.formatForDisplay('12-34-56'), '12-34-56');
      });

      test('truncates to 6 digits', () {
        expect(SortCodeTextFormatter.formatForDisplay('12345678'), '12-34-56');
      });

      test('handles partial input', () {
        expect(SortCodeTextFormatter.formatForDisplay('12'), '12');
        expect(SortCodeTextFormatter.formatForDisplay('1234'), '12-34');
      });
    });

    group('stripDashes', () {
      test('strips dashes from formatted sort code', () {
        expect(SortCodeTextFormatter.stripDashes('12-34-56'), '123456');
      });

      test('returns digits-only unchanged', () {
        expect(SortCodeTextFormatter.stripDashes('123456'), '123456');
      });
    });

    group('formatEditUpdate (input formatter)', () {
      late SortCodeTextFormatter formatter;

      setUp(() {
        formatter = SortCodeTextFormatter();
      });

      test('formats digits as user types', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(text: '123456', selection: TextSelection.collapsed(offset: 6)),
        );
        expect(result.text, '12-34-56');
      });

      test('strips non-digits', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0)),
          const TextEditingValue(text: '12a34b56', selection: TextSelection.collapsed(offset: 8)),
        );
        expect(result.text, '12-34-56');
      });

      test('limits to 6 digits', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '12-34-56', selection: TextSelection.collapsed(offset: 8)),
          const TextEditingValue(text: '12-34-567', selection: TextSelection.collapsed(offset: 9)),
        );
        expect(result.text, '12-34-56');
      });
    });
  });
}
