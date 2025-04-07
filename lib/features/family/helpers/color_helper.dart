import 'dart:ui';

String colorToHex(Color color) {
  return '#'
      '${(color.r * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${(color.g * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${(color.b * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase()}';
}

Color colorFromHex(String hexString) {
  // Remove the leading '#' if present
  hexString = hexString.replaceAll('#', '');

  // Parse the string and add alpha if not provided
  if (hexString.length == 6) {
    hexString = 'FF$hexString'; // Add full opacity if alpha is missing
  }

  // Convert the hex string to an integer and create a Color object
  return Color(int.parse(hexString, radix: 16));
}
