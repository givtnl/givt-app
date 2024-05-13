import 'package:flutter/material.dart';
import 'package:givt_app/features/children/add_member/widgets/allowance_counter.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowancePage extends StatefulWidget {
  const EditAllowancePage({this.initialAllowance, super.key});

  final int? initialAllowance;

  @override
  State<EditAllowancePage> createState() => _EditAllowancePageState();
}

class _EditAllowancePageState extends State<EditAllowancePage> {
  late int _allowance;

  @override
  void initState() {
    super.initState();
    _allowance = widget.initialAllowance ?? 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.createChildGivingAllowanceTitle,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppTheme.inputFieldBorderSelected,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Which amount should be added to',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.childGivingAllowanceHint,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.2,
                      ),
                ),
                Text(
                  "your child's wallet each month?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.childGivingAllowanceHint,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 10),
                AllowanceCounter(
                  currency: "TODO",
                  initialAllowance: _allowance,
                  onAllowanceChanged: (allowance) => setState(() {
                    _allowance = allowance;
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose an amount between TODO1 and TODO999.',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(
                    color: AppTheme
                        .childGivingAllowanceHint,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
                CustomGreenElevatedButton(title: 'Confirm', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
