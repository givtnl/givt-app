import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/routes/pages.dart';

void main() {
  test('old giving flow routes are removed from Pages', () {
    final routeNames = Pages.values.map((page) => page.name).toSet();

    expect(routeNames, contains('FOR-YOU-GIVING'));
    expect(routeNames, isNot(contains('GIVING-WAY')));
    expect(routeNames, isNot(contains('GIVE-BY-BEACON')));
    expect(routeNames, isNot(contains('GIVE-BY-LOCATION')));
    expect(routeNames, isNot(contains('GIVE-BY-QR-CODE')));
    expect(routeNames, isNot(contains('GIVE-BY-LIST')));
    expect(routeNames, isNot(contains('CHOOSE-CATEGORY-LIST')));
  });
}