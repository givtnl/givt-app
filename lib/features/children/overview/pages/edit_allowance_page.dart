import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/overview/widgets/cancel_allowance_dialog.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowancePage extends StatefulWidget {
  const EditAllowancePage({
    required this.currency,
    this.onCancel,
    this.initialAllowance,
    this.extraHeader,
    this.isMultipleChildren = false,
    this.childName = "your child's",
    super.key,
  });

  final String currency;
  final String childName;
  final int? initialAllowance;
  final Widget? extraHeader;
  final bool isMultipleChildren;
  final VoidCallback? onCancel;

  @override
  State<EditAllowancePage> createState() => _EditAllowancePageState();
}

class _EditAllowancePageState extends State<EditAllowancePage> {
  late int _allowance;

  @override
  void initState() {
    super.initState();
    _allowance =
        (widget.initialAllowance == null || widget.initialAllowance == 0)
            ? 15
            : widget.initialAllowance!;
  }

  @override
  Widget build(BuildContext context) {
    final child =
        widget.isMultipleChildren ? 'each of your children' : widget.childName;
    final theme = const FamilyAppTheme().toThemeData();
    return FunScaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Recurring Amount',
        leading: const GivtBackButtonFlat(),
      ),
      body: Center(
        child: Stack(
          children: [
            if (widget.extraHeader != null)
              Align(
                alignment: Alignment.topCenter,
                child: widget.extraHeader,
              ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    calendarClockAvatarIcon(
                      width: 140,
                      height: 140,
                    ),
                    const SizedBox(height: 16),
                    FunCounter(
                      currency: widget.currency,
                      initialAmount: _allowance,
                      onAmountChanged: (allowance) => setState(() {
                        _allowance = allowance;
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'What monthly amount should be added to $child wallet?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppTheme.primary20,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdminFeeText(
                    theme: theme,
                    amount: _allowance.toDouble(),
                    isMonthly: true,
                    isMultipleChildren: widget.isMultipleChildren,
                  ),
                  const SizedBox(height: 4),
                  FunButton(
                    text: context.l10n.confirm,
                    onTap: () {
                      Navigator.of(context).pop(_allowance);
                    },
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.editRGAConfirmClicked,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: widget.initialAllowance != null &&
                        widget.initialAllowance! > 0,
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) => CancelAllowanceDialog(
                            onCancel: () => {widget.onCancel?.call()},
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.topCenter,
                      ),
                      icon: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 16,
                          color: AppTheme.error30,
                        ),
                      ),
                      label: Text(
                        'Cancel Recurring Amount',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: AppTheme.error30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
