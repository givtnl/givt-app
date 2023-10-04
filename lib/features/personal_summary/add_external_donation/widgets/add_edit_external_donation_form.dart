import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';

typedef OnSaveCallback = void Function(ExternalDonation externalDonation);

class AddEditExternalDonationForm extends StatefulWidget {
  const AddEditExternalDonationForm({
    required this.description,
    required this.amount,
    required this.taxDeductable,
    required this.frequency,
    required this.onSave,
    super.key,
  });

  final String description;
  final String amount;
  final ExternalDonationFrequency frequency;

  final bool taxDeductable;
  final OnSaveCallback onSave;

  @override
  State<AddEditExternalDonationForm> createState() =>
      _AddEditExternalDonationFormState();
}

class _AddEditExternalDonationFormState
    extends State<AddEditExternalDonationForm> {
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  bool taxDeductable = false;
  late ExternalDonationFrequency frequency;
  final formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.description);
    amountController = TextEditingController(text: widget.amount);
    taxDeductable = widget.taxDeductable;
    frequency = widget.frequency;
  }

  void onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var externalDonation = ExternalDonation(
      id: '',
      amount: double.parse(amountController.text.replaceAll(',', '.')),
      description: descriptionController.text,
      cronExpression: '',
      creationDate: DateTime.now().toIso8601String(),
      taxDeductable: taxDeductable,
    );

    externalDonation = externalDonation.copyWith(
      frequency: frequency,
    );

    widget.onSave(externalDonation);
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final frequncies = [
      locals.budgetExternalGiftsFrequencyOnce,
      locals.budgetExternalGiftsFrequencyMonthly,
      locals.budgetExternalGiftsFrequencyQuarterly,
      locals.budgetExternalGiftsFrequencyHalfYearly,
      locals.budgetExternalGiftsFrequencyYearly,
    ];
    final country =
        Country.fromCode(context.read<AuthCubit>().state.user.country);

    return BlocListener<AddExternalDonationCubit, AddExternalDonationState>(
      listener: (context, state) {
        if (state.status == AddExternalDonationStatus.loading) {
          setState(() {
            isLoading = true;
          });
        }

        if (state.status == AddExternalDonationStatus.saved ||
            state.status == AddExternalDonationStatus.success) {
          setState(() {
            isLoading = false;
          });
        }

        if (state.isEdit || state.status == AddExternalDonationStatus.success) {
          setState(() {
            descriptionController.text =
                state.currentExternalDonation.description;
            amountController.text = Util.formatNumberComma(
              state.currentExternalDonation.amount,
              country,
            );
            taxDeductable = state.currentExternalDonation.taxDeductable;
            frequency = state.currentExternalDonation.frequency;
            isEdit = state.isEdit;
          });
        }
      },
      child: Form(
        key: formKey,
        child: Card(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  hintText: locals.budgetExternalGiftsOrg,
                  controller: descriptionController,
                  validator: (newValue) {
                    if (newValue == null) {
                      return '';
                    }
                    if (newValue.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ExternalDonationFrequency>(
                        hint: Text(locals.budgetExternalGiftsTime),
                        value: frequency,
                        onChanged: isEdit
                            ? null
                            : (ExternalDonationFrequency? newValue) {
                                if (newValue == null) {
                                  return;
                                }
                                setState(() {
                                  frequency = newValue;
                                });
                              },
                        items: ExternalDonationFrequency.values
                            .map<DropdownMenuItem<ExternalDonationFrequency>>(
                                (ExternalDonationFrequency value) {
                          return DropdownMenuItem<ExternalDonationFrequency>(
                            value: value,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              frequncies[value.index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: isEdit
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        controller: amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            /// Allow only numbers and one comma or dot
                            /// Like 123, 123.45, 12,05, 12,5
                            RegExp(r'^\d+([,.]\d{0,2})?'),
                          ),
                        ],
                        validator: (newValue) {
                          if (newValue == null) {
                            return '';
                          }
                          final amount =
                              double.parse(newValue.replaceAll(',', '.'));
                          if (amount <= 0 || amount > 99999) {
                            return '';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: locals.budgetExternalGiftsAmount,
                          hintText: locals.budgetExternalGiftsAmount,
                          prefixIcon: Icon(
                            Util.getCurrencyIconData(country: country),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  dense: true,
                  title: Text(
                    locals.budgetExternalDonationsTaxDeductableSwitch,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: taxDeductable,
                    activeColor: AppTheme.givtLightGreen,
                    onChanged: (value) {
                      setState(() {
                        taxDeductable = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildAddEditButton(
                  context,
                  onPressed: isLoading || !isEnabled ? null : onSave,
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          isEdit
                              ? locals.budgetExternalGiftsEdit
                              : locals.budgetExternalGiftsAdd,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get isEnabled {
    if (descriptionController.text.isEmpty) {
      return false;
    }
    if (amountController.text.isEmpty) {
      return false;
    }

    return true;
  }

  Widget _buildAddEditButton(
    BuildContext context, {
    required VoidCallback? onPressed,
    required Widget child,
  }) =>
      Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: MediaQuery.sizeOf(context).width / 3,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.givtBlue,
              disabledBackgroundColor: Colors.grey,
            ),
            child: child,
          ),
        ),
      );
}
