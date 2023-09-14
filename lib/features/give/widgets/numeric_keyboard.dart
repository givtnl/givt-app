import 'package:flutter/material.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/utils/app_theme.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatefulWidget {
  const NumericKeyboard({
    required this.onKeyboardTap,
    required this.onPresetTap,
    required this.currencySymbol,
    super.key,
    this.presets = const [],
    this.textColor = Colors.black54,
    this.rightButtonFn,
    this.rightIcon = const Icon(
      Icons.backspace_outlined,
      color: Colors.black54,
    ),
    this.leftButtonFn,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  /// Color of the text [default = Colors.black]
  final Color textColor;

  /// Display a custom right icon
  final Icon? rightIcon;

  /// Action to trigger when right button is pressed
  final VoidCallback? rightButtonFn;

  /// Action to trigger when left button is pressed
  final VoidCallback? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  /// Preset amounts
  final List<Preset> presets;

  /// Callback when a preset is tapped
  final KeyboardTapCallback onPresetTap;

  /// Currency symbol for presets
  final String currencySymbol;

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(8),
      width: size.width,
      height: widget.presets.isNotEmpty ? size.height * 0.3 : null,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Visibility(
            visible: widget.presets.isNotEmpty,
            child: SizedBox(
              width: size.width * 0.3,
              child: Column(
                children: widget.presets.map(
                  (preset) {
                    final amount =
                        preset.amount.toStringAsFixed(2).replaceAll('.', ',');
                    return _buildPresetAmount(
                      preset: amount,
                      onTap: () => widget.onPresetTap(
                        amount,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: [
                    _calcButton('1'),
                    _calcButton('2'),
                    _calcButton('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: [
                    _calcButton('4'),
                    _calcButton('5'),
                    _calcButton('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: [
                    _calcButton('7'),
                    _calcButton('8'),
                    _calcButton('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: [
                    _calcButton(
                      ',',
                      onTap: widget.leftButtonFn,
                    ),
                    _calcButton('0'),
                    _calcButton(
                      '⌫',
                      onTap: widget.rightButtonFn,
                      child: widget.rightIcon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calcButton(
    String value, {
    void Function()? onTap,
    Widget? child,
  }) {
    final onButtonTap = onTap ?? () => widget.onKeyboardTap(value);
    final valueWidget = child ??
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        );
    final size = MediaQuery.sizeOf(context);
    var padding = 14.0;
    if (size.height < 700) {
      padding = 7.5;
    }
    if (size.height < 600) {
      padding = 0;
    }
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: onButtonTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: EdgeInsets.all(padding),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: valueWidget,
        ),
      ),
    );
  }

  Widget _buildPresetAmount({
    required String preset,
    required VoidCallback onTap,
  }) =>
      Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(45),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.presetsButtonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.currencySymbol} $preset',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
}
