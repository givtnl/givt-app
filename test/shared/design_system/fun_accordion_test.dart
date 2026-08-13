import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/components/content/fun_accordion.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: FunGivtTheme().toThemeData(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets(
    'renders TitleSmallText and BodySmallText for title and subtitle',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          FunAccordion(
            title: 'My title',
            subtitle: 'More info',
            isExpanded: false,
            onHeaderTap: () {},
          ),
        ),
      );

      expect(find.byType(TitleSmallText), findsOneWidget);
      expect(find.byType(BodySmallText), findsOneWidget);
      expect(find.byType(TitleMediumText), findsNothing);
      expect(find.byType(BodyMediumText), findsNothing);
      expect(find.text('My title'), findsOneWidget);
      expect(find.text('More info'), findsOneWidget);
    },
  );

  testWidgets('omits BodySmallText when subtitle is null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        FunAccordion(
          title: 'My title',
          isExpanded: false,
          onHeaderTap: () {},
        ),
      ),
    );

    expect(find.byType(TitleSmallText), findsOneWidget);
    expect(find.byType(BodySmallText), findsNothing);
  });

  testWidgets('shows content when expanded and hides when collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        FunAccordion(
          title: 'My title',
          isExpanded: true,
          onHeaderTap: () {},
          content: const Text('Expanded content'),
        ),
      ),
    );

    expect(find.text('Expanded content'), findsOneWidget);

    await tester.pumpWidget(
      _wrap(
        FunAccordion(
          title: 'My title',
          isExpanded: false,
          onHeaderTap: () {},
          content: const Text('Expanded content'),
        ),
      ),
    );

    expect(find.text('Expanded content'), findsNothing);
  });
}
