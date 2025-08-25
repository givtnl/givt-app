import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

typedef KeyboardTapCallback = void Function(String text);

class FunNumericKeyboard extends StatefulWidget {
  const FunNumericKeyboard({
    required this.onKeyboardTap,
    required this.onPresetTap,
    required this.rightButtonFn,
    super.key,
    this.presets = const [],
  });

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Action to trigger when right button is pressed
  final VoidCallback? rightButtonFn;

  /// Preset amounts
  final List<int> presets;

  /// Callback when a preset is tapped
  final KeyboardTapCallback onPresetTap;

  static double getHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var height = 280.0;
    if (size.height < 600) {
      height = height - 60;
    } else if (size.height < 700) {
      height = height - 40;
    }
    return height;
  }

  @override
  State<StatefulWidget> createState() {
    return _FunNumericKeyboardState();
  }
}

class _FunNumericKeyboardState extends State<FunNumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(8),
      width: size.width,
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
          Expanded(
            child: Column(
              children: [
                _presetsRow(widget.presets),
                Row(
                  children: [
                    _calcButton('1'),
                    _calcButton('2'),
                    _calcButton('3'),
                  ],
                ),
                Row(
                  children: [
                    _calcButton('4'),
                    _calcButton('5'),
                    _calcButton('6'),
                  ],
                ),
                Row(
                  children: [
                    _calcButton('7'),
                    _calcButton('8'),
                    _calcButton('9'),
                  ],
                ),
                Row(
                  children: [
                    _calcButton(
                      '',
                    ),
                    _calcButton('0'),
                    _calcButton(
                      '⌫',
                      onTap: widget.rightButtonFn,
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          FontAwesomeIcons.deleteLeft,
                          color: FamilyAppTheme.secondary40,
                        ),
                      ),
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
    final size = MediaQuery.sizeOf(context);

    var textScaler = 1.0;
    if (size.height < 600 && widget.presets.isNotEmpty) {
      textScaler = 0.9;
    }
    final onButtonTap = onTap ?? () => widget.onKeyboardTap(value);
    final valueWidget = child ??
        LabelLargeText(
          value,
          textAlign: TextAlign.center,
          color: FamilyAppTheme.secondary40,
          textScaler: TextScaler.linear(textScaler),
        );

    var padding = 8.0;
    if (size.height < 700) {
      padding = 4;
    }
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: onButtonTap,
        child: Container(
          margin: EdgeInsets.all(size.height < 600 ? 2 : 4),
          padding: EdgeInsets.all(padding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: value.isEmpty ? Colors.grey.shade200 : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: valueWidget,
        ),
      ),
    );
  }

  Widget _presetsRow(List<int> presets) => Container(
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: presets.map(_presetButton).toList(),
        ),
      );

  Widget _presetButton(int amount) => InkWell(
        onTap: () => widget.onPresetTap(amount.toString()),
        child: Container(
          width: MediaQuery.sizeOf(context).width / 4 - 12,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Center(
            child: LabelSmallText.secondary40(
              '\$$amount',
            ),
          ),
        ),
      );
}
