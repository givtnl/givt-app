import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/outlined_input_borders.dart';

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

    return GestureDetector(
      onTapDown: (_) {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: DropdownMenu<Country>(
        dropdownMenuEntries: _buildPopupItems(countries, locals, context),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: selectedInputBorder,
          border: enabledInputBorder,
        ),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: FamilyAppTheme.primary40,
            ),
        menuHeight: 250,
        menuStyle: MenuStyle(
          surfaceTintColor: WidgetStateProperty.resolveWith((states) {
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return Colors.white;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return const BorderSide(
              color: FamilyAppTheme.neutralVariant80,
              width: 2,
            );
          }),
          shape: WidgetStateProperty.resolveWith((states) {
            return const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            );
          }),
        ),
        width: MediaQuery.of(context).size.width - 48,
        initialSelection: selectedCountry,
        trailingIcon: const Icon(
          FontAwesomeIcons.chevronDown,
          color: FamilyAppTheme.primary20,
        ),
        selectedTrailingIcon: const Icon(
          FontAwesomeIcons.chevronUp,
          color: FamilyAppTheme.primary20,
        ),
        onSelected: (Country? country) {
          if (country != null) {
            onChanged?.call(country);
          }
        },
        leadingIcon: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 8, top: 12, bottom: 12),
          child: CountryFlag.fromCountryCode(
            selectedCountry.countryCode,
            shape: const RoundedRectangle(4),
            height: 25,
            width: 35,
          ),
        ),
      ),
    );
  }

  List<DropdownMenuEntry<Country>> _buildPopupItems(
    List<Country> countries,
    AppLocalizations locals,
    BuildContext context,
  ) {
    final items = <DropdownMenuEntry<Country>>[];
    for (var i = 0; i < countries.length; i++) {
      final country = countries[i];

      items.add(
        DropdownMenuEntry<Country>(
          value: country,
          label: Country.getCountry(country.countryCode, locals),
          leadingIcon: CountryFlag.fromCountryCode(
            country.countryCode,
            shape: const RoundedRectangle(4),
            height: 20,
            width: 25,
          ),
          labelWidget: Text(
            Country.getCountry(country.countryCode, locals),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(),
          ),
        ),
      );
    }
    return items;
  }
}
