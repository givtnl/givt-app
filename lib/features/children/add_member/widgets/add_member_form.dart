import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';
import 'package:givt_app/features/children/add_member/widgets/family_text_form_field.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({required this.addDivider, super.key});
  final bool addDivider;
  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool isChildSelected = true;
  int _allowanceController = 15;
  final formKey = GlobalKey<FormState>();

  void _incrementCounter() {
    if (_allowanceController > 998) {
      return;
    }
    setState(() {
      _allowanceController++;
    });
  }

  void _decrementCounter() {
    if (_allowanceController < 2) {
      return;
    }
    setState(() {
      _allowanceController--;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   final memberCubit = context.read<AddMemberCubit>();
  //   if (memberCubit.state.child.firstName == null) {
  //     return;
  //   }
  //   _allowanceController = memberCubit.state.child.allowance!;
  //   _nameController.text = memberCubit.state.child.firstName!;
  //   _ageController.text = memberCubit.state.child.age.toString();
  // }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    final currency = NumberFormat.simpleCurrency(
            name: Country.fromCode(user.country).currency)
        .currencySymbol;

    return BlocConsumer<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
      if (state.formStatus == AddMemberFormStatus.validate) {
        if (formKey.currentState!.validate()) {
          final name = _nameController.text.trim();
          final age = int.parse(_ageController.text);
          final birthYear = DateTime.now().year - age;
          final dateOfBirth = DateTime(birthYear, 1, 1);

          final child = Child(
            firstName: name,
            dateOfBirth: dateOfBirth,
            age: age,
            allowance: _allowanceController,
            key: formKey.toString(),
          );
          context.read<AddMemberCubit>().rememberChild(child: child);
          context.read<AddMemberCubit>().resetFormStatus();
        }
      }
    }, builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.addDivider,
            child: const Divider(
              color: AppTheme.givtGraycece,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 20),
          childOrParentSelector(),
          const SizedBox(height: 10),
          Stack(
            children: [
              animate(
                isVisible: !isChildSelected,
                child: Center(
                  child: Text(
                    context.l10n.soonMessage,
                  ),
                ),
              ),
              animate(
                child: createChildForm(formKey, currency),
                isVisible: isChildSelected,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget childOrParentSelector() => Row(
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
  Widget selectorSegment({
    required String title,
    required bool isSelected,
    required bool isLeft,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            isChildSelected = !isChildSelected;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          width: 120,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            borderRadius: isLeft
                ? const BorderRadius.only(
                    topLeft: const Radius.circular(4),
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
  Widget animate({required Widget child, required bool isVisible}) =>
      AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: child);
  Widget allowanceCounter(String currency) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _decrementCounter,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            icon: Icon(FontAwesomeIcons.circleMinus,
                size: 32,
                color: (_allowanceController < 2)
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: currency,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '$_allowanceController',
                    style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        fontFeatures: <FontFeature>[
                          FontFeature.liningFigures()
                        ]),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _incrementCounter,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: Icon(FontAwesomeIcons.circlePlus,
                size: 32,
                color: (_allowanceController > 998)
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary),
          ),
        ],
      );
  Widget createChildForm(GlobalKey<FormState> formKey, String currency) => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FamilyTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterChildName;
                }
                if (value.length < 2) {
                  return context.l10n.pleaseEnterValidName;
                }
                if (value.length > 20) {
                  return context.l10n.nameTooLong;
                }
                return null;
              },
              controller: _nameController,
              hintText: context.l10n.firstName,
              keyboardType: TextInputType.name,
            ),
            FamilyTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterChildAge;
                }
                if (int.tryParse(value) == null) {
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
              textInputAction: TextInputAction.done,
            ),
            const GivingAllowanceInfoButton(),
            allowanceCounter(currency),
          ],
        ),
      );
}
