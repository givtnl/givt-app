import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/amount_presets/models/preset.dart';
import 'package:givt_app/features/give/widgets/home_goal_tracker.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/pages/pages.dart';
import 'package:givt_app/utils/utils.dart';
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
    required this.arePresetsEnabled,
    required this.presets,
    this.showAddCollectionButton = true,
    this.showFamilyGoal = false,
    super.key,
  });

  final int amountLimit;
  final Country country;
  final bool hasGiven;
  final bool arePresetsEnabled;
  final bool showAddCollectionButton;
  final List<Preset> presets;
  final ChooseAmountNextCallback onAmountChanged;
  final bool showFamilyGoal;

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

  String _comma = ',';
  final String _zero = '0';

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
    // US & UK should have a . instead ,
    if (widget.country.countryCode == Country.us.countryCode ||
        Country.unitedKingdomCodes().contains(widget.country.countryCode)) {
      _comma = '.';
    }

    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    if (widget.hasGiven && !reset) {
      reset = true;
      _resetControllers();
    }

    final currencySymbol = NumberFormat.simpleCurrency(
      name: widget.country.currency,
    ).currencySymbol;

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CollectionFormField(
                        focusNode: focusNodes[0],
                        key: Key(locals.firstCollect),
                        amountLimit: widget.amountLimit,
                        lowerLimit: Util.getLowerLimitByCountry(widget.country),
                        prefixCurrencyIcon:
                            _buildCurrencyIcon(widget.country, 0),
                        suffixText: locals.firstCollect,
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
                          setState(() {
                            reset = false;
                          });
                        },
                        textColor: selectedField == 0
                            ? AppTheme.givtLightPurple
                            : AppTheme.givtDarkerGray,
                      ),
                      CollectionFormField(
                        focusNode: focusNodes[1],
                        key: Key(locals.secondCollect),
                        amountLimit: widget.amountLimit,
                        lowerLimit: Util.getLowerLimitByCountry(widget.country),
                        prefixCurrencyIcon:
                            _buildCurrencyIcon(widget.country, 1),
                        controller: controllers[1],
                        isVisible: collectionFields[1],
                        suffixText: locals.secondCollect,
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
                          setState(() {
                            reset = false;
                          });
                        },
                        textColor: selectedField == 1
                            ? AppTheme.givtLightPurple
                            : AppTheme.givtDarkerGray,
                      ),
                      CollectionFormField(
                        focusNode: focusNodes[2],
                        key: Key(locals.thirdCollect),
                        amountLimit: widget.amountLimit,
                        lowerLimit: Util.getLowerLimitByCountry(widget.country),
                        prefixCurrencyIcon:
                            _buildCurrencyIcon(widget.country, 2),
                        suffixText: locals.thirdCollect,
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
                          setState(() {
                            reset = false;
                          });
                        },
                        textColor: selectedField == 2
                            ? AppTheme.givtLightPurple
                            : AppTheme.givtDarkerGray,
                      ),
                      Visibility(
                        visible: !collectionFields.every(
                              (element) => element == true,
                            ) &&
                            widget.showAddCollectionButton,
                        child: AddCollectionButton(
                          label: locals.addCollect,
                          onPressed: () {
                            setState(() {
                              collectionFields[
                                  collectionFields.indexOf(false)] = true;
                              _changeFocus();
                            });
                          },
                        ),
                      ),
                      if (widget.showFamilyGoal) const HomeGoalTracker(),
                    ],
                  ),
                ),
              ),
              _buildNextButton(
                label: locals.next,
                onPressed: isEnabled
                    ? () async {
                        final areAmountsValid = await _checkAmounts(
                          context,
                          upperLimit: widget.amountLimit,
                          lowerLimit:
                              Util.getLowerLimitByCountry(widget.country),
                          currency: currencySymbol,
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
                currencySymbol: currencySymbol,
                presets: widget.arePresetsEnabled ? widget.presets : [],
                onPresetTap: onPresetTapped,
                onKeyboardTap: onNumberTapped,
                leftButtonFn: onCommaTapped,
                rightButtonFn: onBackspaceTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeFocus() {
    selectedField = collectionFields.lastIndexOf(true);
    focusNodes[collectionFields.lastIndexOf(true)].requestFocus();
    setState(() {
      reset = true;
    });
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

  Icon _buildCurrencyIcon(Country country, int fieldIndex) => Icon(
        Util.getCurrencyIconData(
          country: country,
        ),
        color: selectedField == fieldIndex
            ? AppTheme.givtLightPurple
            : AppTheme.givtDarkerGray,
      );

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
            content:
                context.l10n.givtNotEnough('$currency ${Util.formatNumberComma(
              lowerLimit,
              widget.country,
            )}'),
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
              CupertinoDialogAction(
                child: Text(
                  context.l10n.changeGivingLimit,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async => AuthUtils.checkToken(
                  context,
                  checkAuthRequest: CheckAuthRequest(
                    navigate: (context) => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => ChangeMaxAmountBottomSheet(
                        maxAmount: widget.amountLimit,
                        icon: Util.getCurrencyIconData(
                          country: widget.country,
                        ),
                      ),
                    ).whenComplete(() => context.pop()),
                  ),
                ),
              ),
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

  void onPresetTapped(String amount) {
    controllers[selectedField].text = amount;
    setState(() {
      _formKey.currentState!.validate();
    });
  }

  Padding _buildNextButton({
    required String label,
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
}
