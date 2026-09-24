import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/give/widgets/door_to_door_suggestion_card.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';

void main() {
  const organisation = CollectGroup(
    nameSpace: 'givt.nl.cancsoc',
    orgName: 'Cancer Society',
    hasCelebration: false,
    type: CollectGroupType.charities,
  );

  const featured = FeaturedCollectGroup(
    nameSpace: 'givt.nl.cancsoc',
    logoUrl: '',
  );

  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders org name, tag, and subtitle', (tester) async {
    await tester.pumpWidget(
      wrap(
        DoorToDoorSuggestionCard(
          featured: featured,
          organisation: organisation,
          onTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cancer Society'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Support the door-to-door collection'), findsOneWidget);
  });

  testWidgets('tap invokes callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        DoorToDoorSuggestionCard(
          featured: featured,
          organisation: organisation,
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DoorToDoorSuggestionCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
