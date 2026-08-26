import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/external_donations/create/models/external_donation_create_preview_row.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_preview_panel.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/content/fun_tag.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('one-off preview row renders FunTag without recurring icon',
      (tester) async {
    const panel = ExternalDonationCreatePreviewPanel(
      rows: [
        ExternalDonationCreatePreviewRow(
          organisationName: 'World Vision',
          typeTagLabel: 'Ext. donation',
          amountLabel: '€20.00',
          primarySubtitle: 'One-off',
          isRecurring: false,
        ),
      ],
      showSectionTitle: false,
    );

    await tester.pumpWidget(_wrap(panel));
    await tester.pumpAndSettle();

    final tag = tester.widget<FunTag>(find.byType(FunTag));
    expect(tag.iconData, isNull);
  });

  testWidgets('recurring preview row renders FunTag with recurring icon',
      (tester) async {
    const panel = ExternalDonationCreatePreviewPanel(
      rows: [
        ExternalDonationCreatePreviewRow(
          organisationName: 'World Vision',
          typeTagLabel: 'Ext. donation',
          amountLabel: '€20.00',
          primarySubtitle: 'Monthly',
          isRecurring: true,
        ),
      ],
      showSectionTitle: false,
    );

    await tester.pumpWidget(_wrap(panel));
    await tester.pumpAndSettle();

    final tag = tester.widget<FunTag>(find.byType(FunTag));
    expect(tag.iconData, FontAwesomeIcons.arrowsRotate);
    expect(tag.iconSize, 12);
    expect(tag.variant, FunTagVariant.accent);
  });
}
