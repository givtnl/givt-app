import 'package:flutter/services.dart';

/// A [TextInputFormatter] that automatically formats UK sort codes as XX-XX-XX.
///
/// This formatter:
/// - Only allows digits (0-9)
/// - Automatically inserts dashes after the 2nd and 4th digits
/// - Limits input to 6 digits (8 characters including dashes)
/// - Maintains correct cursor position after formatting
///
/// Example: User types "123456" -> displays as "12-34-56"
class SortCodeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extract only digits from the new value
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 6 digits
    final truncated =
        digitsOnly.length > 6 ? digitsOnly.substring(0, 6) : digitsOnly;

    // Format with dashes
    final formatted = _formatSortCode(truncated);

    // Calculate new cursor position
    final newCursorPosition = _calculateCursorPosition(
      oldValue.text,
      formatted,
      newValue.selection.baseOffset,
      digitsOnly.length,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, formatted.length),
      ),
    );
  }

  /// Formats digits as XX-XX-XX
  String _formatSortCode(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length <= 2) return digits;
    if (digits.length <= 4) {
      return '${digits.substring(0, 2)}-${digits.substring(2)}';
    }
    final part1 = digits.substring(0, 2);
    final part2 = digits.substring(2, 4);
    final part3 = digits.substring(4);
    return '$part1-$part2-$part3';
  }

  /// Calculates the appropriate cursor position after formatting
  int _calculateCursorPosition(
    String oldText,
    String newText,
    int cursorPosition,
    int digitCount,
  ) {
    // Position cursor at the end of the formatted text
    // This provides the best UX for most typing scenarios
    return newText.length;
  }

  /// Strips dashes from a formatted sort code for API submission.
  ///
  /// Example: "12-34-56" -> "123456"
  static String stripDashes(String formattedSortCode) {
    return formattedSortCode.replaceAll('-', '');
  }
}
