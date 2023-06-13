import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/l10n/l10n.dart';


typedef OnMobileNumberChanged = void Function(String selected);

class MobileNumberFormField extends StatelessWidget {
  const MobileNumberFormField({
    super.key,
    required TextEditingController phone, required this.onPrefixChanged, required this.validator,
  }) : _phone = phone;

  final TextEditingController _phone;
  final OnMobileNumberChanged onPrefixChanged;
  final String? Function(String?)? validator;

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
              // value: ,
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
              items: Country.sortedCountries()
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
              controller: _phone,
              validator: validator,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                hintText: locals.phoneNumber,
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
