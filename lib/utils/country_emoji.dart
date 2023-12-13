class CountryEmoji {
  static String getEmoji(String countryCode) {
    if (countryCode.isEmpty) return '';

    // More info about the country codes + emojis: https://en.wikipedia.org/wiki/Regional_indicator_symbol
    final firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;

    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
