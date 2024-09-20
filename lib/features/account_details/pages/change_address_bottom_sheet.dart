import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/util.dart';

class ChangeAddressBottomSheet extends StatefulWidget {
  const ChangeAddressBottomSheet({
    required this.address,
    required this.postalCode,
    required this.city,
    required this.country,
    super.key,
  });

  final String address;
  final String postalCode;
  final String city;
  final String country;

  @override
  State<ChangeAddressBottomSheet> createState() =>
      _ChangeAddressBottomSheetState();
}

class _ChangeAddressBottomSheetState extends State<ChangeAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController address = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController city = TextEditingController();
  late Country selectedCountry;

  @override
  void initState() {
    address.text = widget.address;
    postalCode.text = widget.postalCode;
    city.text = widget.city;
    selectedCountry = Country.fromCode(widget.country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        locals.changeAddress,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      child: BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  hintText: locals.streetAndHouseNumber,
                  controller: address,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: locals.postalCode,
                  controller: postalCode,
                  toUpperCase: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }

                    if (!Country.unitedKingdomCodes()
                        .contains(selectedCountry.countryCode)) {
                      return null;
                    }

                    if (!Util.ukPostCodeRegEx.hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: locals.city,
                  controller: city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<Country>(
                  validator: (value) {
                    if (value == null) {
                      return '';
                    }

                    return null;
                  },
                  value: selectedCountry,
                  decoration: InputDecoration(
                    labelText: locals.country,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 16),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                  ),
                  menuMaxHeight: size.height * 0.3,
                  items: Country.sortedCountries()
                      .where((element) =>
                          element.currency == selectedCountry.currency,)
                      .map(
                        (Country country) => DropdownMenuItem(
                          value: country,
                          child: Text(
                            Country.getCountry(country.countryCode, locals),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (Country? newValue) {
                    setState(() {
                      selectedCountry = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Expanded(child: Container()),
                if (state.status == PersonalInfoEditStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            context.read<PersonalInfoEditBloc>().add(
                                  PersonalInfoEditAddress(
                                    address: address.text,
                                    postalCode: postalCode.text,
                                    city: city.text,
                                    country: selectedCountry.countryCode,
                                  ),
                                );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      locals.save,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return true;
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool toUpperCase = false,
  }) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText,
      validator: validator,
      inputFormatters: toUpperCase ? [UpperCaseTextFormatter()] : [],
      onChanged: (value) => setState(() {
        formKey.currentState!.validate();
      }),
    );
  }
}
