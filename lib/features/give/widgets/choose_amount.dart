import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';

typedef ChooseAmountNextCallback = bool Function(
  double firstCollection,
  double secondCollection,
  double thirdCollection,
);

class ChooseAmount extends StatefulWidget {
  const ChooseAmount({
    required this.amountLimit,
    required this.onAmountChanged,
    required this.country,
    super.key,
  });

  final int amountLimit;
  final String country;
  final ChooseAmountNextCallback onAmountChanged;

  @override
  State<ChooseAmount> createState() => _ChooseAmountState();
}

class _ChooseAmountState extends State<ChooseAmount> {
  final _formKey = GlobalKey<FormState>();
  List<bool> collectionFields = [true, false, false];
  final List<TextEditingController> controllers = [
    TextEditingController(text: '0'),
    TextEditingController(text: '0'),
    TextEditingController(text: '0'),
  ];

  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  int selectedField = 0;

  @override
  void dispose() {
    super.dispose();
    for (var index = 0; index < controllers.length; index++) {
      controllers[index].dispose();
      focusNodes[index].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCollectionField(
                  focusNode: focusNodes[0],
                  collectionFieldName: locals.firstCollect,
                  amountLimit: widget.amountLimit,
                  prefixCurrencyIcon: _buildCurrencyIcon(),
                  controller: controllers[0],
                  isVisible: collectionFields[0],
                  isRemoveIconVisible: collectionFields[1] == true ||
                      collectionFields[2] == true,
                  isSuffixTextVisible: collectionFields[1] == true ||
                      collectionFields[2] == true,
                  onRemoveIconPressed: () => setState(
                    () {
                      controllers[0].text = '0';
                      collectionFields[0] = false;
                      _changeFocus();
                    },
                  ),
                  onFocused: () {
                    selectedField = 0;
                    focusNodes[0].requestFocus();
                  },
                ),
                _buildCollectionField(
                  focusNode: focusNodes[1],
                  collectionFieldName: locals.secondCollect,
                  amountLimit: widget.amountLimit,
                  prefixCurrencyIcon: _buildCurrencyIcon(),
                  controller: controllers[1],
                  isVisible: collectionFields[1],
                  isRemoveIconVisible: collectionFields[0] == true ||
                      collectionFields[2] == true,
                  onRemoveIconPressed: () => setState(() {
                    controllers[1].text = '0';
                    collectionFields[1] = false;
                    _changeFocus();
                  }),
                  onFocused: () {
                    selectedField = 1;
                    focusNodes[1].requestFocus();
                  },
                ),
                _buildCollectionField(
                  focusNode: focusNodes[2],
                  collectionFieldName: locals.thirdCollect,
                  amountLimit: widget.amountLimit,
                  prefixCurrencyIcon: _buildCurrencyIcon(),
                  controller: controllers[2],
                  isVisible: collectionFields[2],
                  isRemoveIconVisible: collectionFields[0] == true ||
                      collectionFields[1] == true,
                  onRemoveIconPressed: () => setState(() {
                    controllers[2].text = '0';
                    collectionFields[2] = false;
                    _changeFocus();
                  }),
                  onFocused: () {
                    selectedField = 2;
                    focusNodes[2].requestFocus();
                  },
                ),
                Visibility(
                  visible: !collectionFields.every(
                    (element) => element == true,
                  ),
                  child: _buildAddCollectionButton(
                    size: size,
                    label: locals.addCollect,
                    onPressed: () {
                      setState(() {
                        collectionFields[collectionFields.indexOf(false)] =
                            true;
                        _changeFocus();
                      });
                    },
                  ),
                ),
                Expanded(child: Container()),
                _buildNextButton(
                  label: locals.next,
                  onPressed: isEnabled
                      ? () {
                          widget.onAmountChanged(
                            double.parse(
                              controllers[0].text.replaceAll(',', '.'),
                            ),
                            double.parse(
                              controllers[1].text.replaceAll(',', '.'),
                            ),
                            double.parse(
                              controllers[2].text.replaceAll(',', '.'),
                            ),
                          );
                        }
                      : null,
                ),
                NumericKeyboard(
                  onKeyboardTap: onNumberTapped,
                  leftButtonFn: onCommaTapped,
                  rightButtonFn: onBackspaceTapped,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeFocus() {
    selectedField = collectionFields.lastIndexOf(true);
    focusNodes[collectionFields.lastIndexOf(true)].requestFocus();
  }

  void _resetControllers() {
    for (var index = 0; index < controllers.length; index++) {
      controllers[index].text = '0';
      focusNodes[index].unfocus();
      collectionFields[index] = index == 0;
    }
    focusNodes[0].requestFocus();
  }

  Icon _buildCurrencyIcon() {
    final countryIso = widget.country;
    var icon = Icons.euro;
    if (countryIso == 'US') {
      icon = Icons.attach_money;
    }
    if (countryIso == 'GB') {
      icon = Icons.currency_pound;
    }

    return Icon(
      icon,
      color: Colors.grey,
    );
  }

  bool get isEnabled {
    if (_formKey.currentState == null) return false;
    if (_formKey.currentState!.validate() == false) return false;

    for (final controller in controllers) {
      if (double.parse(controller.text.replaceAll(',', '.')) != 0) {
        return true;
      }
    }

    return false;
  }

  Widget _buildCollectionField({
    required FocusNode focusNode,
    required String collectionFieldName,
    required int amountLimit,
    required TextEditingController controller,
    required bool isVisible,
    required bool isRemoveIconVisible,
    required VoidCallback onRemoveIconPressed,
    required VoidCallback onFocused,
    required Icon prefixCurrencyIcon,
    bool isSuffixTextVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: CollectionFormField(
        focusNode: focusNode,
        key: Key(collectionFieldName),
        controller: controller,
        amountLimit: amountLimit,
        suffixText: collectionFieldName,
        prefixCurrencyIcon: prefixCurrencyIcon,
        isRemoveIconVisible: isRemoveIconVisible,
        isSuffixTextVisible: isSuffixTextVisible,
        onRemoveIconPressed: onRemoveIconPressed,
        onFocused: onFocused,
      ),
    );
  }

  final String _comma = ',';
  final String _zero = '0';

  void onBackspaceTapped() {
    /// if text has 1 digit then it will be 0
    if (controllers[selectedField].text.length == 1) {
      controllers[selectedField].text = _zero;
      setState(() {
        _formKey.currentState!.validate();
      });
      return;
    }
    controllers[selectedField].text = controllers[selectedField]
        .text
        .substring(0, controllers[selectedField].text.length - 1);
    setState(() {
      _formKey.currentState!.validate();
    });
  }

  void onCommaTapped() {
    if (controllers[selectedField].text.contains(_comma)) {
      return;
    }
    if (controllers[selectedField].text.length > 6) {
      return;
    }
    if (controllers[selectedField].text == _zero) {
      controllers[selectedField].text += _comma;
      setState(() {
        _formKey.currentState!.validate();
      });
      return;
    }
    controllers[selectedField].text += _comma;
    setState(() {
      _formKey.currentState!.validate();
    });
  }

  void onNumberTapped(String value) {
    /// if comma is already in text and there is 2 digits after comma
    if (controllers[selectedField].text.contains(_comma) &&
        controllers[selectedField].text.split(_comma)[1].length == 2) {
      return;
    }

    if (controllers[selectedField].text == _zero) {
      controllers[selectedField].text = value;
      setState(() {
        _formKey.currentState!.validate();
      });
      return;
    }

    /// if text is longer than 6 digits
    if (controllers[selectedField].text.length <= 6) {
      controllers[selectedField].text += value;
    }
    setState(() {
      _formKey.currentState!.validate();
    });
  }

  Padding _buildNextButton({
    required String label,
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: const Icon(Icons.arrow_forward_ios_outlined),
        icon: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(label),
        ),
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.white,
          disabledBackgroundColor: Colors.black12,
          minimumSize: const Size(50, 40),
        ),
      ),
    );
  }

  Container _buildAddCollectionButton({
    required Size size,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Center(
        child: DottedBorder(
          color: Colors.black54,
          strokeCap: StrokeCap.round,
          dashPattern: const [3, 6],
          borderPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          borderType: BorderType.RRect,
          radius: const Radius.circular(6),
          padding: const EdgeInsets.all(6),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_circle_outlined),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black54,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(50, 40),
            ),
          ),
        ),
      ),
    );
  }
}
