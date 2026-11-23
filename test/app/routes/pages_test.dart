import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/routes/pages.dart';

void main() {
  group('Pages.fromPath', () {
    test('returns the page for a known path', () {
      expect(Pages.fromPath(Pages.home.path), Pages.home);
      expect(Pages.fromPath(Pages.forYouGiving.path), Pages.forYouGiving);
    });

    test('returns null for an unknown path so home can stay put', () {
      expect(Pages.fromPath('select-giving-way'), isNull);
      expect(Pages.fromPath('does-not-exist'), isNull);
      expect(Pages.fromPath(''), isNull);
    });
  });
}
