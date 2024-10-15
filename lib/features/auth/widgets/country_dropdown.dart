import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';

class CountryDropDown extends StatefulWidget {
  const CountryDropDown({
    required this.selectedCountry,
    required this.onChanged,
    this.focusNode,
    super.key,
  });

  final Country selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final FocusNode? focusNode;

  @override
  State<CountryDropDown> createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final countries = Country.sortedCountries()
        .where((element) => element != Country.unknown)
        .toList();

    return DropdownButton2<Country>(
        items: _buildPopupItems(countries, locals, context),
        focusNode: widget.focusNode,
        underline: const SizedBox.shrink(),
        dropdownStyleData: DropdownStyleData(
          scrollbarTheme: ScrollbarThemeData(
            thickness: WidgetStateProperty.all<double>(0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 1),
          maxHeight: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FamilyAppTheme.neutralVariant80,
              width: 2,
            ),
          ),
          width: MediaQuery.of(context).size.width - 48,
        ),
        isExpanded: true,
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 1),
          height: 58,
        ),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isOpen
                  ? FamilyAppTheme.primary70
                  : FamilyAppTheme.neutralVariant80,
              width: 2,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: FamilyAppTheme.primary40,
            ),
        value: widget.selectedCountry,
        onChanged: (Country? country) {
          if (country != null) {
            widget.onChanged?.call(country);
            widget.focusNode?.unfocus();
          }
        },
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              FontAwesomeIcons.chevronDown,
              color: FamilyAppTheme.primary20,
            ),
          ),
          openMenuIcon: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              FontAwesomeIcons.chevronUp,
              color: FamilyAppTheme.primary20,
            ),
          ),
        ),
        onMenuStateChange: (bool isOpen) {
          setState(() {
            _isOpen = isOpen;
          });
        },
        selectedItemBuilder: (BuildContext context) => _buildPopupItems(
              countries,
              locals,
              context,
              isSelected: true,
            ));
  }

  List<DropdownMenuItem<Country>> _buildPopupItems(
      List<Country> countries, AppLocalizations locals, BuildContext context,
      {bool isSelected = false}) {
    final items = <DropdownMenuItem<Country>>[];
    for (var i = 0; i < countries.length; i++) {
      final country = countries[i];

      items.add(
        _dropdownMenuItem(
          country,
          locals,
          hideDivider: isSelected || i == countries.length - 1,
        ),
      );
    }
    return items;
  }

  DropdownMenuItem<Country> _dropdownMenuItem(
      Country country, AppLocalizations locals,
      {bool hideDivider = false}) {
    return DropdownMenuItem<Country>(
      value: country,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 24),
                CountryFlag.fromCountryCode(
                  country.countryCode,
                  shape: const RoundedRectangle(4),
                  height: 20,
                  width: 25,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LabelLargeText(
                    Country.getCountry(country.countryCode, locals),
                  ),
                ),
              ],
            ),
          ),
          if (!hideDivider)
            Container(
              height: 1,
              color: FamilyAppTheme.neutralVariant95,
            ),
        ],
      ),
    );
  }
}
