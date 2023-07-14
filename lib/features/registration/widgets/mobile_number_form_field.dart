import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/l10n/l10n.dart';

typedef OnMobileNumberChanged = void Function(String selected);

class MobileNumberFormField extends StatelessWidget {
  const MobileNumberFormField({
    required this.phone,
    required this.onPrefixChanged,
    required this.onPhoneChanged,
    required this.selectedCountryPrefix,
    required this.validator,
    super.key,
  });

  final TextEditingController phone;
  final OnMobileNumberChanged onPrefixChanged;
  final OnMobileNumberChanged onPhoneChanged;
  final String? Function(String?)? validator;
  final String selectedCountryPrefix;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedCountryPrefix,
              menuMaxHeight: size.height * 0.3,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                errorStyle: TextStyle(
                  height: 0,
                ),
              ),
              items: Country.sortedPrefixCountries()
                  .map(
                    (Country category) => DropdownMenuItem(
                      value: category.prefix,
                      child: Text(
                        category.prefix,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                onPrefixChanged(newValue!);
              },
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: phone,
              validator: validator,
              onChanged: onPhoneChanged,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                hintText: locals.mobileNumberUsDigits,
                labelText: locals.phoneNumber,
                labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                    ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                errorStyle: const TextStyle(
                  height: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
