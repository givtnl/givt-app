import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/donation_type_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';

class RecurringDonationsDetailPage extends StatelessWidget {
  const RecurringDonationsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Selected Organisation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          _buildAppBarItem(
              context: context,
              icon: const Icon(Icons.info_rounded),
              child: DontaionTypeExplanationSheet())
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: AppTheme.givtGrayf3f3f3,
        child: Column(
          children: [
            Text('Recurring Donations Detail Page'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarItem({
    // required GivtState state,
    required BuildContext context,
    required Widget child,
    required Icon icon,
    Color? color,
  }) {
    return Visibility(
      visible: true,
      //state.givtGroups.isNotEmpty,
      child: IconButton(
        icon: icon,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: color ?? AppTheme.givtBlue,
          builder: (context) =>
              Container(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }
}
