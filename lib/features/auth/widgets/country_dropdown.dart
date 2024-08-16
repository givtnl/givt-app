import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class CountryDropDown extends StatelessWidget {
  const CountryDropDown({
    required this.selectedCountry,
    required this.onChanged,
    super.key,
  });

  final Country selectedCountry;
  final ValueChanged<Country?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final countries = Country.sortedCountries()
        .where((element) => element != Country.unknown)
        .toList();

    return PopupMenuButton<Country>(
      initialValue: selectedCountry,
      onSelected: (Country? country) {
        if (country != null) {
          onChanged?.call(country);
        }
      },
      itemBuilder: (BuildContext context) {
        return _buildPopupItems(countries, locals);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: AppTheme.inputFieldBorderEnabled,
          width: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      color: Colors.white,
      offset: const Offset(0, 200),
      constraints: BoxConstraints(
        minWidth: MediaQuery.sizeOf(context).width - 32,
        maxWidth: MediaQuery.sizeOf(context).width - 32,
        minHeight: MediaQuery.sizeOf(context).height * 0.3,
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.inputFieldBorderEnabled, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            CountryFlag.fromCountryCode(
              selectedCountry.countryCode,
              shape: const RoundedRectangle(4),
              height: 20,
              width: 25,
            ),
            const SizedBox(width: 4),
            Text(
              Country.getCountry(selectedCountry.countryCode, locals),
              style:
                  FamilyAppTheme().toThemeData().textTheme.labelLarge?.copyWith(
                        color: AppTheme.primary40,
                      ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_downward_rounded, color: AppTheme.primary20),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<Country>> _buildPopupItems(
      List<Country> countries, AppLocalizations locals) {
    final items = <PopupMenuEntry<Country>>[];
    for (var i = 0; i < countries.length; i++) {
      final country = countries[i];

      items.add(PopupMenuItem<Country>(
        value: country,
        child: Row(
          children: [
            CountryFlag.fromCountryCode(
              country.countryCode,
              shape: const RoundedRectangle(4),
              height: 20,
              width: 25,
            ),
            const SizedBox(width: 4),
            Text(Country.getCountry(country.countryCode, locals)),
          ],
        ),
      ));

      // Add a divider between items except after the last item
      if (i < countries.length - 1) {
        items.add(const PopupMenuDivider(height: 1));
      }
    }
    return items;
  }
}
