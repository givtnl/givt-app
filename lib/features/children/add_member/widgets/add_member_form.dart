import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/profile.dart';
import 'package:givt_app/features/children/add_member/widgets/family_text_form_field.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm(
      {required this.firstMember, required this.onRemove, super.key});
  final bool firstMember;
  final VoidCallback onRemove;

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _nameChildController = TextEditingController();
  final _nameParentController = TextEditingController();
  final _ageController = TextEditingController();
  bool isChildSelected = true;
  int _allowanceController = 15;
  final formKeyChild = GlobalKey<FormState>();
  final formKeyParent = GlobalKey<FormState>();

  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

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
            if (!formKeyChild.currentState!.validate()) {
              cubit.resetFormStatus();
              return;
            }

            final name = _nameChildController.text.trim();
            final age = int.parse(_ageController.text);
            final birthYear = DateTime.now().year - age;
            final dateOfBirth = DateTime(birthYear);

            final profile = Member(
              firstName: name,
              dateOfBirth: dateOfBirth,
              age: age,
              allowance: _allowanceController,
              key: formKeyChild.toString(),
              type: 'Child',
            );

            cubit.rememberProfile(
                member: profile, invisibleSecondKey: formKeyParent.toString());
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.addChildProfile,
              eventProperties: {
                'name': name,
                'age': age,
                'allowance': _allowanceController,
              },
            );
          } else {
            if (!formKeyParent.currentState!.validate()) {
              cubit.resetFormStatus();
              return;
            }

            final name = _nameParentController.text.trim();

            final profile = Member(
              firstName: name,
              key: formKeyParent.toString(),
              type: 'Parent',
            );

            cubit.rememberProfile(
                member: profile, invisibleSecondKey: formKeyChild.toString());

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.addParentProfile,
              eventProperties: {
                'name': name,
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
                      color: Theme.of(context).colorScheme.primary,
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

  Widget allowanceCounter(String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          splashRadius: 24,
          onPressed: _decrementCounter,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
          icon: Icon(
            FontAwesomeIcons.circleMinus,
            size: 32,
            color: (_allowanceController < 2)
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
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
                    fontFeatures: <FontFeature>[FontFeature.liningFigures()],
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          splashRadius: 24,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: _incrementCounter,
          padding: EdgeInsets.zero,
          icon: Icon(
            FontAwesomeIcons.circlePlus,
            size: 32,
            color: (_allowanceController > 998)
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
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
            keyboardType: TextInputType.name,
            focusNode: _nameFocusNode,
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
          ),
          const SizedBox(height: 10),
          const GivingAllowanceInfoButton(),
          allowanceCounter(currency),
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
            keyboardType: TextInputType.name,
          ),
        ],
      ),
    );
  }
}
