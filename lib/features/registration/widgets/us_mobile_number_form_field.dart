import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

import '../../family/utils/utils.dart';

typedef OnMobileNumberChanged = void Function(String selected);

class MobileNumberFormFieldUs extends StatelessWidget {
  const MobileNumberFormFieldUs({
    required this.phone,
    required this.onPrefixChanged,
    required this.onPhoneChanged,
    required this.selectedCountryPrefix,
    required this.hintText,
    required this.validator,
    this.formatter,
    super.key,
  });

  final TextEditingController phone;
  final OnMobileNumberChanged onPrefixChanged;
  final OnMobileNumberChanged onPhoneChanged;
  final String? Function(String?)? validator;
  final String selectedCountryPrefix;
  final String hintText;
  final List<TextInputFormatter>? formatter;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          child: DropdownButtonFormField<String>(
            value: selectedCountryPrefix,
            menuMaxHeight: size.height * 0.3,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
              errorStyle: const TextStyle(
                height: 0,
              ),
              enabledBorder: enabledInputBorder,
              focusedBorder: selectedInputBorder,
              errorBorder: errorInputBorder,
              border: enabledInputBorder,
            ),
            items: Country.sortedPrefixCountries()
                .map(
                  (Country category) => DropdownMenuItem(
                    value: category.prefix,
                    child: Text(
                      category.prefix,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              onPrefixChanged(newValue!);
            },
            icon: const Icon(
              Icons.arrow_downward,
              color: FamilyAppTheme.primary30,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          flex: 2,
          child: OutlinedTextFormField(
            inputFormatters: formatter != null ? [...formatter!] : null,
            controller: phone,
            validator: validator,
            onChanged: onPhoneChanged,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            hintText: hintText,
            errorStyle: const TextStyle(
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}
