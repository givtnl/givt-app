import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';

typedef OnMobileNumberChanged = void Function(String selected);

class MobileNumberFormField extends StatelessWidget {
  const MobileNumberFormField({
    required this.phone,
    required this.onPrefixChanged,
    required this.onPhoneChanged,
    required this.selectedCountryPrefix,
    required this.hintText,
    required this.validator,
    this.formatter,
    this.autofillHints = const [AutofillHints.telephoneNumberLocal],
    super.key,
  });

  final TextEditingController phone;
  final OnMobileNumberChanged onPrefixChanged;
  final OnMobileNumberChanged onPhoneChanged;
  final String? Function(String?)? validator;
  final String selectedCountryPrefix;
  final String hintText;
  final List<TextInputFormatter>? formatter;
  final List<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FunInputDropdown<String>(
              value: selectedCountryPrefix,
              onChanged: (String? newValue) {
                onPrefixChanged(newValue!);
              },
              items: Country.sortedPrefixCountries()
                  .map((country) => country.prefix)
                  .toList(),
              itemBuilder: (context, prefix) => Text(
                prefix,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 2,
            child: OutlinedTextFormField(
              inputFormatters: formatter != null ? [...formatter!] : null,
              controller: phone,
              validator: validator,
              onChanged: onPhoneChanged,
              keyboardType: TextInputType.phone,
              autofillHints: autofillHints,
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
