import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: FunGivtTheme().toThemeData(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('prefix icon uses a compact leading slot aligned with text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const FunInput(
          hintText: 'Select',
          prefixIcon: Icon(Icons.search, size: 24),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    final decoration = textField.decoration!;

    expect(decoration.isDense, isTrue);
    expect(
      decoration.prefixIconConstraints,
      const BoxConstraints(minWidth: 0, minHeight: 0),
    );
    expect(
      decoration.contentPadding,
      const EdgeInsets.fromLTRB(0, 12, 16, 12),
    );

    final slot = tester.widget<SizedBox>(
      find.descendant(
        of: find.byWidget(decoration.prefixIcon!),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 30 && widget.height == 24,
        ),
      ),
    );
    expect(slot.width, 30);
    expect(slot.height, 24);
  });

  testWidgets('fields without a prefix keep default padding', (tester) async {
    await tester.pumpWidget(_wrap(const FunInput(hintText: 'Email')));

    final textField = tester.widget<TextField>(find.byType(TextField));
    final decoration = textField.decoration!;

    expect(decoration.isDense, isNot(true));
    expect(decoration.prefixIconConstraints, isNull);
    expect(
      decoration.contentPadding,
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  });
}
