import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/give/pages/qr_code_scan_page.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';

class ChooseAmount extends StatefulWidget {
  const ChooseAmount({
    required this.amountLimit,
    super.key,
  });

  final int amountLimit;

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

  int selectedField = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCollectionField(
                  collectionFieldName: locals.firstCollect,
                  amountLimit: widget.amountLimit,
                  controller: controllers[0],
                  isVisible: collectionFields[0],
                  isRemoveIconVisible: collectionFields[1] == true ||
                      collectionFields[2] == true,
                  onRemoveIconPressed: () => setState(
                    () {
                      collectionFields[0] = false;
                    },
                  ),
                  onFocused: () => selectedField = 0,
                ),
                _buildCollectionField(
                  collectionFieldName: locals.secondCollect,
                  amountLimit: widget.amountLimit,
                  controller: controllers[1],
                  isVisible: collectionFields[1],
                  isRemoveIconVisible: collectionFields[0] == true ||
                      collectionFields[2] == true,
                  onRemoveIconPressed: () => setState(() {
                    collectionFields[1] = false;
                  }),
                  onFocused: () => selectedField = 1,
                ),
                _buildCollectionField(
                  collectionFieldName: locals.thirdCollect,
                  amountLimit: widget.amountLimit,
                  controller: controllers[2],
                  isVisible: collectionFields[2],
                  isRemoveIconVisible: collectionFields[0] == true ||
                      collectionFields[1] == true,
                  onRemoveIconPressed: () => setState(() {
                    collectionFields[2] = false;
                  }),
                  onFocused: () => selectedField = 2,
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
                      });
                    },
                  ),
                ),
                Expanded(child: Container()),
                _buildNextButton(
                  label: locals.next,
                  onPressed: () => Navigator.of(context).push(
                    QrCodeScanPage.route(),
                  ),
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

  Widget _buildCollectionField({
    required String collectionFieldName,
    required int amountLimit,
    required TextEditingController controller,
    required bool isVisible,
    required bool isRemoveIconVisible,
    required VoidCallback onRemoveIconPressed,
    required VoidCallback onFocused,
  }) {
    return Visibility(
      visible: isVisible,
      child: CollectionFormField(
        key: Key(collectionFieldName),
        controller: controller,
        amountLimit: amountLimit,
        suffixText: collectionFieldName,
        isRemoveIconVisible: isRemoveIconVisible,
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
      _formKey.currentState!.validate();
      return;
    }
    controllers[selectedField].text = controllers[selectedField]
        .text
        .substring(0, controllers[0].text.length - 1);
    _formKey.currentState!.validate();
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
      return;
    }
    controllers[selectedField].text += _comma;
    _formKey.currentState!.validate();
  }

  void onNumberTapped(String value) {
    /// if comma is already in text and there is 2 digits after comma
    if (controllers[selectedField].text.contains(_comma) &&
        controllers[selectedField].text.split(_comma)[1].length == 2) {
      return;
    }

    if (controllers[selectedField].text == _zero) {
      controllers[selectedField].text = value;
      return;
    }

    /// if text is longer than 6 digits
    if (controllers[selectedField].text.length <= 6) {
      controllers[selectedField].text += value;
    }
    _formKey.currentState!.validate();
  }

  Padding _buildNextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: const Icon(Icons.arrow_forward_ios_outlined),
        icon: Text(label),
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
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
      margin: EdgeInsets.only(
        top: 10,
        right: size.width * 0.17,
      ),
      child: DottedBorder(
        color: Colors.grey,
        strokeCap: StrokeCap.round,
        dashPattern: const [3, 6],
        borderPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add_circle_outlined),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
            backgroundColor: Colors.transparent,
            minimumSize: const Size(50, 40),
          ),
        ),
      ),
    );
  }
}
