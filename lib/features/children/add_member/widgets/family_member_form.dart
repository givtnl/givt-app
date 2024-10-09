import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/admin_fee/presentation/widgets/admin_fee_text.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';

class FamilyMemberForm extends StatelessWidget {
  const FamilyMemberForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.ageController,
    required this.isChildSelected,
    required this.allowanceAmount,
    required this.onAmountChanged,
    this.showTopUp = false,
    super.key,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController ageController;
  final int allowanceAmount;
  final void Function(int amount) onAmountChanged;
  final bool isChildSelected;
  final bool showTopUp;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: isChildSelected
          ? _buildChildForm(context, nameController, ageController)
          : _buildParentForm(context, nameController, emailController),
    );
  }

  Widget _buildChildForm(
    BuildContext context,
    TextEditingController nameChildController,
    TextEditingController ageController,
  ) {
    return Column(
      children: [
        OutlinedTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.pleaseEnterChildName;
            }
            if (value.length < 3) {
              return context.l10n.pleaseEnterValidName;
            }
            if (value.length > 20) {
              return context.l10n.nameTooLong;
            }
            return null;
          },
          controller: nameChildController,
          hintText: context.l10n.firstName,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 16),
        OutlinedTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.pleaseEnterChildAge;
            }
            if (int.tryParse(value) == null) {
              return context.l10n.pleaseEnterValidAge;
            }
            if (int.parse(value) < 1) {
              return context.l10n.pleaseEnterValidAge;
            }
            if (int.parse(value) > 18) {
              return context.l10n.addAdultInstead;
            }
            return null;
          },
          controller: ageController,
          hintText: context.l10n.ageKey,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24),
        if(showTopUp) const BodySmallText(
          "Start your child's giving journey by adding funds to their Wallet",
          textAlign: TextAlign.center,
        ),
        if(showTopUp) const SizedBox(height: 12),
        if(showTopUp) FunCounter(
          currency: r'$',
          initialAmount: allowanceAmount,
          canAmountBeZero: true,
          onAmountChanged: onAmountChanged,
        ),
        if(showTopUp) const SizedBox(height: 12),
        if(showTopUp) AdminFeeText(
          amount: allowanceAmount.toDouble(),
          textStyle: const FamilyAppTheme().toThemeData().textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildParentForm(
    BuildContext context,
    TextEditingController nameChildController,
    TextEditingController emailController,
  ) {
    return Column(
      children: [
        OutlinedTextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.pleaseEnterChildName;
            }
            if (value.length < 3) {
              return context.l10n.pleaseEnterValidName;
            }
            if (value.length > 20) {
              return context.l10n.nameTooLong;
            }
            return null;
          },
          controller: nameChildController,
          hintText: context.l10n.firstName,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 16),
        OutlinedTextFormField(
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !Util.emailRegEx.hasMatch(value)) {
              return context.l10n.invalidEmail;
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [
            AutofillHints.username,
            AutofillHints.email,
          ],
          controller: emailController,
          hintText: context.l10n.email,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16),
        const BodySmallText(
          'They will receive an email inviting them to the family, enabling them to also:',
        ),
        const SizedBox(height: 8),
        _createDescriptionItem('Login to Givt with their own account'),
        _createDescriptionItem('Approve donations of the children'),
        _createDescriptionItem('Explore generosity as a family'),
      ],
    );
  }

  Widget _createDescriptionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, right: 8),
            child: Icon(
              FontAwesomeIcons.check,
              color: AppTheme.primary40,
              size: 16,
            ),
          ),
          BodySmallText(
            text,
          ),
        ],
      ),
    );
  }
}
