import 'package:flutter/material.dart';
import 'package:givt_app/features/children/add_member/widgets/allowance_counter.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';

class AddTopUpPage extends StatefulWidget {
  const AddTopUpPage({
    required this.currency,
    this.initialAmount,
    super.key,
  });

  final String currency;
  final int? initialAmount;

  @override
  State<AddTopUpPage> createState() => _AddTopUpPageState();
}

class _AddTopUpPageState extends State<AddTopUpPage> {
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        plusIcon(
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.topUp,
                          textAlign: TextAlign.center,
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
                          context.l10n.topUpScreenInfo,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: AppTheme.givtBlue,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    height: 1.2,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        AllowanceCounter(
                          currency: widget.currency,
                          initialAllowance: _amount,
                          onAllowanceChanged: (amount) => setState(() {
                            _amount = amount;
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
                  child: CustomGreenElevatedButton(
                    title: context.l10n.confirm,
                    onPressed: () {
                      Navigator.of(context).pop(_amount);
                    },
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
