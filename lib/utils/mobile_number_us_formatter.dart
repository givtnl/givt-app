import 'package:flutter/services.dart';

class MobileNumberFormatterEEE extends TextInputFormatter {
  MobileNumberFormatterEEE();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var holder = newValue.text;
    if (newValue.text.contains('1')) {
      holder = newValue.text.replaceAll('1', '2');
    }
    return TextEditingValue(
      text: holder,
      selection: TextSelection.collapsed(offset: holder.length),
    );
  }
}

class MobileNumberFormatter extends TextInputFormatter {
  MobileNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final numberStr =
        newValue.text.replaceAll('-', '').replaceAll('_', '').padRight(10, '_');

    final chunkSize = [3, 3, 4];
    var startIndex = 0;

    final chunks = chunkSize.map((size) {
      final chunk = numberStr.substring(startIndex, startIndex + size);
      startIndex += size;
      return chunk;
    });
    final formatted = chunks.join('-');
    var cursorPosition = newValue.selection.baseOffset;
    if (formatted.replaceAll('_', '').length == 8 ||
        formatted.replaceAll('_', '').length == 5) {
      cursorPosition = cursorPosition + 1;
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: cursorPosition,
      ),
    );
  }
}
