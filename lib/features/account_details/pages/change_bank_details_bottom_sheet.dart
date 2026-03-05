import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/util.dart';
import 'package:iban/iban.dart';

class ChangeBankDetailsBottomSheet extends StatefulWidget {
  const ChangeBankDetailsBottomSheet({
    required this.iban,
    required this.accountNumber,
    required this.sortCode,
    super.key,
  });

  final String iban;
  final String accountNumber;
  final String sortCode;

  @override
  State<ChangeBankDetailsBottomSheet> createState() =>
      _ChangeBankDetailsBottomSheetState();
}

class _ChangeBankDetailsBottomSheetState
    extends State<ChangeBankDetailsBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController iban = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController sortCode = TextEditingController();

  @override
  void initState() {
    iban.text = widget.iban;
    accountNumber.text = widget.accountNumber;
    sortCode.text = SortCodeTextFormatter.formatForDisplay(widget.sortCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        widget.iban.isNotEmpty
            ? locals.changeIban
            : locals.changeBankAccountNumberAndSortCode,
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
                  isVisibile: widget.iban.isNotEmpty,
                  hintText: locals.ibanPlaceHolder,
                  controller: iban,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!isValid(value)) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  isVisibile: widget.iban.isEmpty,
                  hintText: locals.sortCodePlaceholder,
                  controller: sortCode,
                  inputFormatters: [SortCodeTextFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return locals.fieldRequired;
                    }
                    if (!Util.ukSortCodeRegEx.hasMatch(value)) {
                      return locals.sortCodeMustBe6Digits;
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  isVisibile: widget.iban.isEmpty,
                  hintText: locals.bankAccountNumberPlaceholder,
                  controller: accountNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (value.length != 8) {
                      return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.05),
                Expanded(child: Container()),
                if (state.status == PersonalInfoEditStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      context.read<PersonalInfoEditBloc>().add(
                            PersonalInfoEditBankDetails(
                              iban: iban.text,
                              accountNumber: accountNumber.text,
                              sortCode: SortCodeTextFormatter.stripDashes(
                                sortCode.text,
                              ),
                            ),
                          );
                    },
                    child: Text(locals.save),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isVisibile = true,
    TextInputType? keyboardType = TextInputType.number,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Visibility(
      visible: isVisibile,
      child: CustomTextFormField(
        controller: controller,
        hintText: hintText,
        validator: validator,
        onChanged: (value) => setState(() {
          formKey.currentState!.validate();
        }),
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        inputFormatters: inputFormatters ?? const [],
      ),
    );
  }
}
