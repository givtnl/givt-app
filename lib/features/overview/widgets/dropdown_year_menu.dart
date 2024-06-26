import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

typedef OnYearChanged = void Function(String selected);

class YearOfDonationsDropdown extends StatelessWidget {
  const YearOfDonationsDropdown(
      {required this.donationYears,
      required this.selectedYear,
      required this.onYearChanged,
      super.key,});
  final List<String> donationYears;
  final String selectedYear;
  final OnYearChanged onYearChanged;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DropdownButtonFormField<String>(
      validator: (value) {
        if (value == null) {
          return '';
        }

        return null;
      },
      value: selectedYear,
      // _getYears(state).contains(_overviewYearController)
      //     ? _overviewYearController
      //     : _getYears(state).first,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.givtBlue,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.givtBlue,
          ),
        ),
        errorStyle: TextStyle(
          height: 0,
        ),
      ),
      menuMaxHeight: size.height * 0.3,
      items: donationYears
          .map(
            (String country) => DropdownMenuItem(
              value: country,
              child: Text(
                country,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
          .toList(),
      onChanged: (String? newValue) {
        onYearChanged(newValue!);
      },
    );
  }
}
