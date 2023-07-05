enum Country {
  be('+32', 'BE'),
  nl('+31', 'NL'),
  de('+49', 'DE'),
  fr('+33', 'FR'),
  it('+39', 'IT'),
  lu('+352', 'LU'),
  gr('+30', 'GR'),
  pt('+351', 'PT'),
  es('+34', 'ES'),
  fi('+358', 'FI'),
  at('+43', 'AT'),
  cy('+357', 'CY'),
  ee('+372', 'EE'),
  lv('+371', 'LV'),
  lt('+370', 'LT'),
  mt('+356', 'MT'),
  si('+386', 'SI'),
  sk('+421', 'SK'),
  ie('+353', 'IE'),
  ad('+376', 'AD', isBACS: true),
  gb('+44', 'GB', isBACS: true),
  je('+44', 'JE', isBACS: true),
  gg('+44', 'GG', isBACS: true),
  us('+1', 'US', isCreditCard: true),
  unknown('', '');

  const Country(
    this.prefix,
    this.countryCode, {
    this.isBACS = false,
    this.isCreditCard = false,
  });
  final String prefix;
  final String countryCode;
  final bool isBACS;
  final bool isCreditCard;

  static List<Country> sortedCountries() {
    return Country.values.toList()
      ..sort((a, b) => a.countryCode.compareTo(b.countryCode))
      ..remove(Country.us);
  }

  static List<Country> sortedPrefixCountries() {
    final countries = sortedCountries();
    for (var i = 0; i < countries.length; i++) {
      final country = countries[i];
      if (country == Country.je || country == Country.gg) {
        countries.remove(country);
      }
    }
    return countries;
  }

  static List<String> unitedKingdomCodes() {
    return [
      Country.gb.countryCode,
      Country.je.countryCode,
      Country.gg.countryCode,
    ];
  }
}
