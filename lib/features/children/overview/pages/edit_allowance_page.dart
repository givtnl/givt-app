import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/add_member/widgets/allowance_counter.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/overview/widgets/cancel_allowance_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowancePage extends StatefulWidget {
  const EditAllowancePage({
    required this.currency,
    this.onCancel,
    this.initialAllowance,
    this.extraHeader,
    this.isMultipleChildren = false,
    this.fee = 0.65,
    super.key,
  });

  final String currency;
  final double fee;
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
    final perchild = widget.isMultipleChildren ? ' per child' : '';
    final theme = FamilyAppTheme().toThemeData();
    return Scaffold(
      appBar: const TopAppBar(
        title: 'Recurring Amount',
        leading: GenerosityBackButton(),
      ),
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
                        calendarClockAvatarIcon(),
                        const SizedBox(height: 16),
                        AllowanceCounter(
                          currency: widget.currency,
                          initialAllowance: _allowance,
                          onAllowanceChanged: (allowance) => setState(() {
                            _allowance = allowance;
                          }),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "What monthly amount should be added to $child's wallet?",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: AppTheme.primary20,
                              fontFamily: 'Rouna',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
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
                      Text(
                        'Admin fee of ${widget.fee.toStringAsFixed(2)} applies$perchild monthly',
                        style: theme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      GivtElevatedButton(
                        text: context.l10n.confirm,
                        onTap: () {
                          Navigator.of(context).pop(_allowance);
                        },
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
                                fontWeight: FontWeight.w700),
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
