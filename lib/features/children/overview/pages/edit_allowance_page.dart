import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/features/children/add_member/widgets/allowance_counter.dart';
import 'package:givt_app/features/children/overview/widgets/cancel_allowance_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowancePage extends StatefulWidget {
  const EditAllowancePage({
    required this.currency,
    this.onCancel,
    this.initialAllowance,
    this.extraHeader,
    this.isMultipleChildren = false,
    super.key,
  });

  final String currency;
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
        widget.isMultipleChildren ? 'each of your children' : 'your child';
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                        calendarClockIcon(),
                        const SizedBox(height: 16),
                        Text(
                          textAlign: TextAlign.center,
                          context.l10n.createChildGivingAllowanceTitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppTheme.inputFieldBorderSelected,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Which amount should be added to\n'
                          "$child's wallet each month?",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: AppTheme.givtBlue,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        AllowanceCounter(
                          currency: widget.currency,
                          initialAllowance: _allowance,
                          onAllowanceChanged: (allowance) => setState(() {
                            _allowance = allowance;
                          }),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          textAlign: TextAlign.center,
                          'Choose an amount between ${widget.currency}1 and '
                          '${widget.currency}999.',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppTheme.givtBlue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
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
                      CustomGreenElevatedButton(
                        title: context.l10n.confirm,
                        onPressed: () {
                          Navigator.of(context).pop(_allowance);
                        },
                      ),
                      Visibility(
                        visible: widget.initialAllowance != null &&
                            widget.initialAllowance! > 0,
                        child: TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) => CancelAllowanceDialog(
                                onCancel: () => {widget.onCancel?.call()},
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.topCenter,
                          ),
                          child: Text(
                            'Cancel Recurring Giving Allowance',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppTheme.error50,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppTheme.error50,
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
        ),
      ),
    );
  }
}
