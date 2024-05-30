import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/utils/member_utils.dart';
import 'package:givt_app/features/children/add_member/widgets/allowance_counter.dart';
import 'package:givt_app/features/children/add_member/widgets/family_text_form_field.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({
    required this.firstMember,
    required this.onRemove,
    required this.ageFocusNode,
    super.key,
  });

  final bool firstMember;
  final VoidCallback onRemove;
  final FocusNode ageFocusNode;

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _nameChildController = TextEditingController();
  final _nameParentController = TextEditingController();
  final _emailParentController = TextEditingController();
  final _ageController = TextEditingController();
  bool isChildSelected = true;
  int _allowance = 15;
  final formKeyChild = GlobalKey<FormState>();
  final formKeyParent = GlobalKey<FormState>();
  late final FocusNode _childNameFocusNode;
  late final FocusNode _parentNameFocusNode;

  @override
  void dispose() {
    _childNameFocusNode.dispose();
    _parentNameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _childNameFocusNode = FocusNode()..requestFocus();
    _parentNameFocusNode = FocusNode()..requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    final currency = NumberFormat.simpleCurrency(
            name: Country.fromCode(user.country).currency)
        .currencySymbol;

    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        if (state.formStatus == AddMemberFormStatus.validate) {
          final cubit = context.read<AddMemberCubit>();
          if (isChildSelected) {
            final validation = formKeyChild.currentState!.validate();
            LoggingInfo.instance.info(
              'Form is valid: $validation',
              methodName: 'listenerToValidation',
            );
            if (!formKeyChild.currentState!.validate()) {
              cubit.resetFormStatus();
              return;
            }

            final name = _nameChildController.text.trim();
            final age = int.parse(_ageController.text);
            final dateOfBirth = getDateOfBirthFromAge(age);

            final profile = Member(
              firstName: name,
              dateOfBirth: dateOfBirth,
              age: age,
              allowance: _allowance,
              key: formKeyChild.toString(),
              type: ProfileType.Child,
            );

            cubit.rememberProfile(
              member: profile,
              invisibleSecondKey: formKeyParent.toString(),
            );
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.addChildProfile,
              eventProperties: {
                'name': name,
                'age': age,
                'allowance': _allowance,
              },
            );
          } else {
            if (!formKeyParent.currentState!.validate()) {
              cubit.resetFormStatus();
              return;
            }

            final name = _nameParentController.text.trim();
            final email = _emailParentController.text.trim();

            final profile = Member(
              firstName: name,
              key: formKeyParent.toString(),
              type: ProfileType.Parent,
              email: email,
            );

            cubit.rememberProfile(
              member: profile,
              invisibleSecondKey: formKeyChild.toString(),
            );

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.addParentProfile,
              eventProperties: {
                'name': name,
                'email': email,
              },
            );
          }
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: !widget.firstMember,
              child: const Divider(
                color: AppTheme.givtGraycece,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                childOrParentSelector(),
                if (widget.firstMember) const SizedBox(width: 40),
                if (!widget.firstMember)
                  SizedBox(
                    child: IconButton(
                      icon: const Icon(FontAwesomeIcons.trash),
                      color: Theme.of(context).colorScheme.error,
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 40,
                      ),
                      splashRadius: 24,
                      iconSize: 20,
                      onPressed: () {
                        widget.onRemove();
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                if (!isChildSelected) createParentForm(),
                if (isChildSelected) createChildForm(currency),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget childOrParentSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selectorSegment(
          title: context.l10n.childKey,
          isSelected: isChildSelected,
          isLeft: true,
        ),
        selectorSegment(
          title: context.l10n.parentKey,
          isSelected: !isChildSelected,
          isLeft: false,
        ),
      ],
    );
  }

  Widget selectorSegment({
    required String title,
    required bool isSelected,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChildSelected = !isChildSelected;
          isChildSelected
              ? _childNameFocusNode.requestFocus()
              : _parentNameFocusNode.requestFocus();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: 120,
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
          border: isSelected
              ? Border.all()
              : const Border.fromBorderSide(
                  BorderSide(
                    color: AppTheme.givtGraycece,
                  ),
                ),
        ),
        child: isSelected
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                ),
              ),
      ),
    );
  }

  Widget createChildForm(String currency) {
    return Form(
      key: formKeyChild,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FamilyTextFormField(
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
            controller: _nameChildController,
            hintText: context.l10n.firstName,
            textCapitalization: TextCapitalization.sentences,
            focusNode: _childNameFocusNode,
          ),
          FamilyTextFormField(
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
            controller: _ageController,
            hintText: context.l10n.ageKey,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.done,
            focusNode: widget.ageFocusNode,
          ),
          const SizedBox(height: 10),
          const GivingAllowanceInfoButton(),
          AllowanceCounter(
            currency: currency,
            initialAllowance: _allowance,
            onAllowanceChanged: (allowance) => _allowance = allowance,
          ),
        ],
      ),
    );
  }

  Widget createParentForm() {
    return Form(
      key: formKeyParent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FamilyTextFormField(
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
            controller: _nameParentController,
            hintText: context.l10n.firstName,
            textCapitalization: TextCapitalization.sentences,
            focusNode: _parentNameFocusNode,
          ),
          FamilyTextFormField(
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
            autocorrect: false,
            controller: _emailParentController,
            hintText: context.l10n.email,
            textInputAction: TextInputAction.done,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Column(
              children: [
                Text(
                  context.l10n.addAdultMemberDescriptionTitle,
                  style: GoogleFonts.mulish(
                    textStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                  ),
                ),
                const SizedBox(height: 7),
                _createDescriptionItem(
                  context.l10n.addAdultMemberDescriptionItem1,
                ),
                _createDescriptionItem(
                  context.l10n.addAdultMemberDescriptionItem2,
                ),
                _createDescriptionItem(
                  context.l10n.addAdultMemberDescriptionItem3,
                ),
              ],
            ),
          ),
        ],
      ),
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
              color: AppTheme.primary70,
              size: 12,
            ),
          ),
          Text(
            text,
            style: GoogleFonts.mulish(
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
