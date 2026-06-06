import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/uppercase_text_formatter.dart';
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
  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  late Country selectedCountry;
  late final String _initialAddress;
  late final String _initialPostalCode;
  late final String _initialCity;
  late final String _initialCountryCode;

  @override
  void initState() {
    postalCodeController.text = widget.postalCode;
    cityController.text = widget.city;
    selectedCountry = Country.fromCode(widget.country);
    _initialPostalCode = widget.postalCode;
    _initialCity = widget.city;
    _initialCountryCode = widget.country;
    _initialAddress = widget.address;

    if (selectedCountry.isNetherlands) {
      final split = Util.splitNetherlandsAddress(widget.address);
      streetController.text = split.street;
      houseNumberController.text = split.houseNumber;
    } else {
      addressController.text = widget.address;
    }
    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    streetController.dispose();
    houseNumberController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  bool get _isNl => selectedCountry.isNetherlands;

  bool get _isUk =>
      Country.unitedKingdomCodes().contains(selectedCountry.countryCode);

  String get _combinedAddress => _isNl
      ? Util.combineNetherlandsAddress(
          street: streetController.text,
          houseNumber: houseNumberController.text,
        )
      : addressController.text;

  void _onCountryChanged(Country newCountry) {
    final wasNl = selectedCountry.isNetherlands;
    final isNl = newCountry.isNetherlands;

    if (!wasNl && isNl) {
      final split = Util.splitNetherlandsAddress(addressController.text);
      streetController.text = split.street;
      houseNumberController.text = split.houseNumber;
    } else if (wasNl && !isNl) {
      addressController.text = Util.combineNetherlandsAddress(
        street: streetController.text,
        houseNumber: houseNumberController.text,
      );
    }

    setState(() {
      selectedCountry = newCountry;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
      builder: (context, state) {
        final isLoading = state.status == PersonalInfoEditStatus.loading;
        final isSuccess = state.status == PersonalInfoEditStatus.success;

        if (isSuccess) {
          return FunBottomSheet(
            closeAction: () => completePersonalInfoEditSheet(context),
            title: locals.success,
            content: FunIcon.checkmark(),
            primaryButton: FunButton(
              text: locals.buttonDone,
              onTap: () => completePersonalInfoEditSheet(context),
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.editAddressSaveClicked,
              ),
            ),
          );
        }

        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: locals.changeAddress,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                ..._buildStreetFields(locals),
                const SizedBox(height: 16),
                InputFormField(
                  controller: postalCodeController,
                  label: locals.postalCode,
                  hintText: locals.postalCode,
                  inputFormatters:
                      _isUk ? [UpperCaseTextFormatter()] : const [],
                  validator: _postalCodeValidator(locals),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                InputFormField(
                  controller: cityController,
                  label: locals.city,
                  hintText: locals.city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                _buildCountryField(locals),
              ],
            ),
          ),
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading ? _onSave : null,
            text: isLoading ? locals.loadingTitle : locals.save,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.editAddressSaveClicked,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStreetFields(AppLocalizations locals) {
    if (_isNl) {
      return [
        InputFormField(
          controller: streetController,
          label: locals.street,
          hintText: locals.street,
          validator: _requiredValidator,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        InputFormField(
          controller: houseNumberController,
          label: locals.houseNumber,
          hintText: locals.houseNumber,
          validator: _requiredValidator,
          onChanged: (_) => setState(() {}),
        ),
      ];
    }

    return [
      InputFormField(
        controller: addressController,
        label: _isUk ? locals.address : locals.streetAndHouseNumber,
        hintText: _isUk ? locals.address : locals.streetAndHouseNumber,
        validator: _requiredValidator,
        onChanged: (_) => setState(() {}),
      ),
    ];
  }

  Widget _buildCountryField(AppLocalizations locals) {
    return FormField<Country>(
      initialValue: selectedCountry,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value == null ? '' : null,
      builder: (field) {
        return FunInputDropdown<Country>(
          label: locals.country,
          value: selectedCountry,
          errorText: field.errorText,
          items: Country.sortedCountries()
              .where(
                (country) => country.currency == selectedCountry.currency,
              )
              .toList(),
          itemBuilder: (context, country) => Text(
            Country.getCountry(country.countryCode, locals),
          ),
          onChanged: (country) {
            field.didChange(country);
            _onCountryChanged(country);
          },
        );
      },
    );
  }

  String? Function(String?) _postalCodeValidator(AppLocalizations locals) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '';
      }
      if (!_isUk) {
        return null;
      }
      final formattedPostCode = Util.formatUkPostCode(value);
      if (formattedPostCode == null) {
        return locals.enterValidPostcode;
      }
      if (formattedPostCode != postalCodeController.text) {
        postalCodeController.text = formattedPostCode;
      }
      return null;
    };
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return null;
  }

  void _onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.read<PersonalInfoEditBloc>().add(
          PersonalInfoEditAddress(
            address: _combinedAddress,
            postalCode: postalCodeController.text,
            city: cityController.text,
            country: selectedCountry.countryCode,
          ),
        );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (!formKey.currentState!.validate()) return false;

    return _combinedAddress != _initialAddress ||
        postalCodeController.text != _initialPostalCode ||
        cityController.text != _initialCity ||
        selectedCountry.countryCode != _initialCountryCode;
  }
}
