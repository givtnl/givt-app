import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

typedef ChooseAmountNextCallback = void Function(
  double firstCollection,
  double secondCollection,
  double thirdCollection,
);

class ChooseAmount extends StatefulWidget {
  const ChooseAmount({
    required this.amountLimit,
    required this.onAmountChanged,
    required this.country,
    required this.hasGiven,
    super.key,
  });

  final int amountLimit;
  final Country country;
  final bool hasGiven;
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
  bool reset = false;

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
    if (widget.hasGiven && !reset) {
      reset = true;
      _resetControllers();
    }

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
                  lowerLimit: getLowerLimitByCountry(widget.country),
                  prefixCurrencyIcon: _buildCurrencyIcon(widget.country),
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
                  lowerLimit: getLowerLimitByCountry(widget.country),
                  prefixCurrencyIcon: _buildCurrencyIcon(widget.country),
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
                  lowerLimit: getLowerLimitByCountry(widget.country),
                  prefixCurrencyIcon: _buildCurrencyIcon(widget.country),
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
                      ? () async {
                          final areAmountsValid = await _checkAmounts(
                            context,
                            upperLimit: widget.amountLimit,
                            lowerLimit: getLowerLimitByCountry(widget.country),
                            currency: NumberFormat.simpleCurrency(
                              name: widget.country.currency,
                            ).currencySymbol,
                          );

                          if (!areAmountsValid) {
                            return;
                          }
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
                          setState(() {
                            reset = false;
                          });
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

  double getLowerLimitByCountry(Country country) {
    if (country == Country.us) {
      return 2;
    }
    if (Country.unitedKingdomCodes().contains(country.countryCode)) {
      return 0.50;
    }
    return 0.25;
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
    _changeFocus();
    setState(() {
      reset = true;
    });
  }

  Icon _buildCurrencyIcon(Country country) {
    var icon = Icons.euro;
    if (country == Country.us) {
      icon = Icons.attach_money;
    }
    if (Country.unitedKingdomCodes().contains(country.countryCode)) {
      icon = Icons.currency_pound;
    }

    return Icon(
      icon,
      color: Colors.grey,
    );
  }

  Future<bool> _checkAmounts(
    BuildContext context, {
    required double lowerLimit,
    required int upperLimit,
    required String currency,
  }) async {
    for (final controller in controllers) {
      final amount = double.parse(controller.text.replaceAll(',', '.'));
      if (amount == 0) {
        continue;
      }
      if (amount < lowerLimit) {
        await showDialog<void>(
          context: context,
          builder: (_) => WarningDialog(
            title: context.l10n.amountTooLow,
            content: context.l10n.givtNotEnough('$currency $lowerLimit'),
            onConfirm: () => context.pop(),
          ),
        );
        return false;
      }
      if (amount > upperLimit) {
        await showDialog<void>(
          context: context,
          builder: (_) => WarningDialog(
            title: context.l10n.amountTooHigh,
            content: context.l10n.amountLimitExceeded,
            actions: [
              CupertinoDialogAction(
                child: Text(
                  context.l10n.chooseLowerAmount,
                ),
                onPressed: () => context.pop(),
              ),
              // CupertinoDialogAction(
              //   child: Text(
              //     context.l10n.changeGivingLimit,
              //     style: const TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // )
            ],
          ),
        );
        return false;
      }
    }
    return true;
  }

  bool get isEnabled {
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
    double lowerLimit = 0,
  }) {
    return Visibility(
      visible: isVisible,
      child: CollectionFormField(
        focusNode: focusNode,
        key: Key(collectionFieldName),
        controller: controller,
        amountLimit: amountLimit,
        lowerLimit: lowerLimit,
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
