import 'package:flutter/material.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';

class AnnualSummaryCard extends StatelessWidget {
  const AnnualSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardLayout(
      title: 'Annual Summary',
      child: Text('Annual Summary'),
    );
  }
}
