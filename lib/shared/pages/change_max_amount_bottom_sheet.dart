import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/app_theme.dart';

class ChangeMaxAmountBottomSheet extends StatefulWidget {
  const ChangeMaxAmountBottomSheet({
    required this.icon,
    required this.maxAmount,
    super.key,
  });

  final int maxAmount;
  final IconData icon;

  @override
  State<ChangeMaxAmountBottomSheet> createState() =>
      _ChangeMaxAmountBottomSheetState();
}

class _ChangeMaxAmountBottomSheetState
    extends State<ChangeMaxAmountBottomSheet> {
  late TextEditingController amount;
  bool get isEnabled {
    final enteredAmount = int.parse(amount.text);
    if (enteredAmount == 0) {
      amount.selection = TextSelection(
        baseOffset: 0,
        extentOffset: amount.text.length,
      );
      return false;
    }
    if (enteredAmount == widget.maxAmount) {
      return false;
    }
    return true;
  }

  void increaseAmount() {
    if (int.parse(amount.text) == 99999) {
      return;
    }
    amount.text = (int.parse(amount.text) + 5).toString();
  }

  void decreaseAmount() {
    if (int.parse(amount.text) == 0) {
      return;
    }
    amount.text = (int.parse(amount.text) - 5).toString();
  }

  @override
  void initState() {
    amount = TextEditingController(text: widget.maxAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    return BottomSheetLayout(
      title: Text(locals.giveLimit),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            locals.amountLimit,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.filled(
                onPressed: decreaseAmount,
                icon: const Icon(
                  FontAwesomeIcons.circleMinus,
                ),
                color: AppTheme.softenedGivtPurple,
                iconSize: size.width * 0.1,
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.givtLightGreen,
                      width: 7,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: size.width * 0.04,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.15,
                      child: TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            amount.text = '0';
                          }
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 27,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: increaseAmount,
                icon: const Icon(
                  FontAwesomeIcons.circlePlus,
                ),
                color: AppTheme.softenedGivtPurple,
                iconSize: size.width * 0.1,
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: isEnabled
                ? () {
                    print('save');
                  }
                : null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.grey,
            ),
            child: Text(locals.save),
          ),
        ],
      ),
    );
  }
}
