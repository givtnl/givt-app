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
  gg('+44', 'GG', isBACS: true);

  const Country(
    this.prefix,
    this.countryCode, {
    this.isBACS = false,
  });
  final String prefix;
  final String countryCode;
  final bool isBACS;

  static List<Country> sortedCountries() {
    return Country.values.toList()
      ..sort((a, b) => a.countryCode.compareTo(b.countryCode));
  }
}
