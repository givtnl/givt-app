import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

// Returns the first scrollable of a widget matching with the key
Finder findScrollableByKey(Key key) {
  final scrollable = find.byKey(key);
  return find.descendant(
    of: scrollable,
    matching: find.byType(Scrollable).at(0),
  );
}

Finder findScrollableByKeyValue(String value) => findScrollableByKey(
      ValueKey(
        value,
      ),
    );


