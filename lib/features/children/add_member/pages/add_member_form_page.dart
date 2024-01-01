// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';
import 'package:givt_app/features/children/add_member/widgets/family_text_form_field.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool isChildSelected = true;
  int _allowanceController = 15;

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
  void initState() {
    final memeberCubit = context.read<AddMemberCubit>();
    if (memeberCubit.state.child != null) {
      _allowanceController = memeberCubit.state.child!.allowance!;
      _nameController.text = memeberCubit.state.child!.firstName!;
      _ageController.text = memeberCubit.state.child!.age!.toString();
    }
    super.initState();
  }

  void _createChildProfile() {
    final name = _nameController.text.trim();
    final age = int.parse(_ageController.text);
    final birthYear = DateTime.now().year - age;
    final dateOfBirth = DateTime(birthYear, 1, 1);

    final child = Child(
      firstName: name,
      dateOfBirth: dateOfBirth,
      age: age,
      allowance: _allowanceController,
    );
    context.read<AddMemberCubit>().goToVPC(child: child);

    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.createChildProfileClicked,
      eventProperties: {
        'name': name,
        'age': age,
        'allowance': _allowanceController,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final user = context.read<AuthCubit>().state.user;
    final currency = NumberFormat.simpleCurrency(
      name: Util.getCurrencyName(country: Country.fromCode(user.country)),
    ).currencySymbol;

    return BlocBuilder<AddMemberCubit, AddMemberState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              setUpFamilyHeader(),
              const SizedBox(height: 32),
              childOrParentSelector(),
              const SizedBox(height: 10),
              animate(
                child: createChildForm(formKey),
                isVisible: isChildSelected,
              ),
              animate(
                child: const GivingAllowanceInfoButton(),
                isVisible: isChildSelected,
              ),
              animate(
                child: allowanceCounter(currency),
                isVisible: isChildSelected,
              ),
              animate(
                isVisible: !isChildSelected,
                child: Text(
                  'Coming soon',
                ),
              ),
              if (View.of(context).viewInsets.bottom <= 0) const Spacer(),
              continueButton(formKey: formKey, enabled: isChildSelected),
            ],
          ),
        );
      },
    );
  }

  Widget animate({required Widget child, required bool isVisible}) =>
      AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: child);

  Widget childOrParentSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          selectorSegment(
            title: 'Child',
            isSelected: isChildSelected,
            isLeft: true,
          ),
          selectorSegment(
            title: 'Parent',
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
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            borderRadius: isLeft
                ? BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
            border: isSelected
                ? Border.all()
                : Border.fromBorderSide(
                    BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
          ),
          child: isSelected
              ? Row(
                  children: [
                    Icon(
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
                            fontSize: 18,
                          ),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                ),
        ),
      );
  Widget allowanceCounter(String currency) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _decrementCounter,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            icon: Icon(Icons.remove_circle,
                size: 40,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '$_allowanceController',
                    style: const TextStyle(
                      fontSize: 32,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                    ),
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
            icon: Icon(Icons.add_circle,
                size: 40,
                color: (_allowanceController > 998)
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary),
          ),
        ],
      );

  Widget createChildForm(GlobalKey<FormState> formKey) => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FamilyTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the child's name";
                }
                if (value.length < 2) {
                  return 'Please enter a valid name';
                }
                if (value.length > 20) {
                  return 'Name is too long';
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
                  return "Please enter the child's age";
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid age';
                }
                if (int.parse(value) > 18) {
                  return 'Please add an adult instead';
                }
                return null;
              },
              controller: _ageController,
              hintText: 'Age',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      );

  Widget setUpFamilyHeader() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Set up Family\n',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
          children: [
            TextSpan(
              text: 'Who will be joining you?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      );
  Widget continueButton(
      {required GlobalKey<FormState> formKey, bool enabled = true}) {
    return ElevatedButton(
      onPressed: enabled
          ? () {
              if (formKey.currentState!.validate()) {
                _createChildProfile();
              }
            }
          : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppTheme.givtLightGreen : Colors.grey,
      ),
      child: Text(
        "Continue",
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
