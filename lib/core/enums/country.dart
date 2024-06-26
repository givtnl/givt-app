import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/country_emoji.dart';

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
  ad('+376', 'AD', isBACS: true, currency: 'GBP'),
  gb('+44', 'GB', isBACS: true, currency: 'GBP'),
  je('+44', 'JE', isBACS: true, currency: 'GBP'),
  gg('+44', 'GG', isBACS: true, currency: 'GBP'),
  us('+1', 'US', isCreditCard: true, currency: 'USD'),
  unknown('', '');

  const Country(
    this.prefix,
    this.countryCode, {
    this.isBACS = false,
    this.isCreditCard = false,
    this.currency = 'EUR',
  });

  final String prefix;
  final String currency;
  final String countryCode;
  final bool isBACS;
  final bool isCreditCard;

  bool get isUS => countryCode == Country.us.countryCode;

  static List<Country> sortedCountries() {
    return Country.values.toList()
      ..sort((a, b) => a.countryCode.compareTo(b.countryCode));
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

  static Country fromCode(String code) {
    return Country.values.firstWhere(
      (country) => country.countryCode.toUpperCase() == code.toUpperCase(),
      orElse: () => Country.unknown,
    );
  }

  ///To-do this should be done straight from the localizations.
  ///Delete all the countries and
  ///add only one unified string separated by commas and then split it
  static String getCountry(String countryCode, AppLocalizations locals) {
    switch (countryCode) {
      case 'JE':
        return locals.jersey;
      case 'GG':
        return locals.guernsey;
      case 'AD':
        return locals.countryStringAd;
      case 'GB':
        return locals.countryStringGb;
      case 'DE':
        return locals.countryStringDe;
      case 'FR':
        return locals.countryStringFr;
      case 'IT':
        return locals.countryStringIt;
      case 'ES':
        return locals.countryStringEs;
      case 'NL':
        return locals.countryStringNl;
      case 'BE':
        return locals.countryStringBe;
      case 'AT':
        return locals.countryStringAt;
      case 'PT':
        return locals.countryStringPt;
      case 'IE':
        return locals.countryStringIe;
      case 'FI':
        return locals.countryStringFi;
      case 'LU':
        return locals.countryStringLu;
      case 'SI':
        return locals.countryStringSi;
      case 'SK':
        return locals.countryStringSk;
      case 'EE':
        return locals.countryStringEe;
      case 'LV':
        return locals.countryStringLv;
      case 'LT':
        return locals.countryStringLt;
      case 'GR':
        return locals.countryStringGr;
      case 'CY':
        return locals.countryStringCy;
      case 'MT':
        return locals.countryStringMt;
      case 'US':
        return locals.countryStringUs;
      default:
        return '';
    }
  }

  static String getCountryIncludingEmoji(
    String countryCode,
    AppLocalizations locals,
  ) {
    return '${CountryEmoji.getEmoji(countryCode)} ${getCountry(countryCode, locals)}';
  }
}
