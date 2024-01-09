import 'dart:async';
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
  late final FocusNode _childNameFocusNode;
  late final FocusNode _parentNameFocusNode;
  Timer? _timer;
  Duration _heldDuration = Duration.zero;
  int tapTime = 240;
  int holdDownDuration = 1000;
  int holdDownDuration2 = 2000;
  int maxAllowance = 999;
  int minAllowance = 1;
  int allowanceIncrement = 5;
  int allowanceIncrement2 = 10;

  void _startTimer(void Function() callback) {
    _timer = Timer.periodic(Duration(milliseconds: tapTime), (_) {
      _heldDuration += Duration(milliseconds: tapTime);
      callback();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _heldDuration = Duration.zero;
  }

  @override
  void dispose() {
    _stopTimer();
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

  void _incrementCounter() {
    final isHeldDurationShortEnoughForIncrement1 =
        (_heldDuration.inMilliseconds > holdDownDuration) &&
            _allowanceController >= maxAllowance - allowanceIncrement;
    final isHeldDurationShortEnoughForIncrement2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _allowanceController >= maxAllowance - allowanceIncrement2;

    if (_allowanceController >= maxAllowance ||
        isHeldDurationShortEnoughForIncrement1 ||
        isHeldDurationShortEnoughForIncrement2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _allowanceController += (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? allowanceIncrement
              : allowanceIncrement2;
      ;
    });
  }

  void _decrementCounter() {
    final isHeldDurationLongEnoughForNegative1 =
        (_heldDuration.inMilliseconds > holdDownDuration) &&
            _allowanceController <= minAllowance + allowanceIncrement;
    final isHeldDurationLongEnoughForNegative2 =
        (_heldDuration.inMilliseconds > holdDownDuration2) &&
            _allowanceController <= minAllowance + allowanceIncrement2;

    if (_allowanceController <= minAllowance ||
        isHeldDurationLongEnoughForNegative1 ||
        isHeldDurationLongEnoughForNegative2) {
      return;
    }
    setState(() {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      _allowanceController -= (_heldDuration.inMilliseconds < holdDownDuration)
          ? 1
          : (_heldDuration.inMilliseconds < holdDownDuration2)
              ? allowanceIncrement
              : allowanceIncrement2;
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

  Widget allowanceCounter(String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTapDown: (_) {
            _startTimer(_decrementCounter);
          },
          onTapUp: (_) {
            _stopTimer();
          },
          onTapCancel: _stopTimer,
          onTap: (_allowanceController < 2) ? null : _decrementCounter,
          child: Container(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circleMinus,
              size: 32,
              color: (_allowanceController < 2)
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: _allowanceController < 100 ? 75 : 95,
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
        GestureDetector(
          onTapDown: (_) {
            _startTimer(_incrementCounter);
          },
          onTapUp: (_) {
            _stopTimer();
          },
          onTapCancel: _stopTimer,
          onTap: (_allowanceController > 998) ? null : _incrementCounter,
          child: Container(
            width: 32,
            height: 32,
            child: Icon(
              FontAwesomeIcons.circlePlus,
              size: 32,
              color: (_allowanceController > 998)
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
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
            textCapitalization: TextCapitalization.words,
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
            textCapitalization: TextCapitalization.words,
            focusNode: _parentNameFocusNode,
          ),
        ],
      ),
    );
  }
}
