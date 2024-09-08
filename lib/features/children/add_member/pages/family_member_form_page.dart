import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_loading_page.dart';
import 'package:givt_app/features/children/add_member/widgets/child_or_parent_selector.dart';
import 'package:givt_app/features/children/add_member/widgets/family_member_form.dart';
import 'package:givt_app/features/children/add_member/widgets/smiley_counter.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/utils.dart';

class FamilyMemberFormPage extends StatefulWidget {
  const FamilyMemberFormPage({
    required this.index,
    required this.totalCount,
    required this.membersToCombine,
    super.key,
  });

  final int index;
  final int totalCount;
  final List<Member> membersToCombine;

  @override
  State<FamilyMemberFormPage> createState() => _FamilyMemberFormPageState();
}

class _FamilyMemberFormPageState extends State<FamilyMemberFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _focusNode = FocusNode();
  List<bool> selections = [true, false];
  int _amount = 5;

  @override
  void initState() {
    super.initState();
  }

  Member? addMember({bool isChildSelected = false}) {
    if (_formKey.currentState!.validate()) {
      final newMember = isChildSelected
          ? Member(
              firstName: _nameController.text,
              age: int.parse(_ageController.text),
              allowance: _amount,
              type: ProfileType.Child,
            )
          : Member(
              firstName: _nameController.text,
              email: _emailController.text,
              type: ProfileType.Parent,
            );
      return newMember;
    }
    return null;
  }

  void onDone({bool isChildSelected = false}) {
    final member = addMember(isChildSelected: isChildSelected);

    if (member != null) {
      final members = [
        ...widget.membersToCombine,
        member,
      ];
      if (members.any((member) => member.isChild)) {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => VPCPage(
            onReadyClicked: () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.vpcAccepted,
              );
              submitMembersAndNavigate(members: members);
            },
          ),
        );
      } else {
        submitMembersAndNavigate(members: members);
      }
    }
  }

  void submitMembersAndNavigate({List<Member> members = const []}) {
    getIt<AddMemberCubit>()
      ..addAllMembers(members)
      ..createMember();

    Navigator.push(context, const AddMemberLoadingPage().toRoute(context));
  }

  @override
  Widget build(BuildContext context) {
    final isLast = widget.index == widget.totalCount;
    final isChildSelected = selections[0];
    final keyboardIsVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return FunScaffold(
        appBar: FunTopAppBar.primary99(
          title: 'Set up Family',
          leading: const GenerosityBackButton(),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SmileyCounter(
                totalCount: widget.totalCount,
                index: widget.index,
              ),
              ChildOrParentSelector(
                selections: selections,
                onPressed: (int index) {
                  setState(() {
                    selections = [index == 0, index == 1];

                    FocusScope.of(context).unfocus();
                    _focusNode.requestFocus();
                  });
                },
              ),
              const SizedBox(height: 16),
              FamilyMemberForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                ageController: _ageController,
                allowanceAmount: _amount,
                focusNode: _focusNode,
                onAmountChanged: (amount) {
                  setState(() {
                    _amount = amount;
                  });
                },
                isChildSelected: isChildSelected,
              ),
              const SizedBox(height: 40),
              if (keyboardIsVisible && isLast)
                _primaryButton(isChildSelected)
              else if (keyboardIsVisible)
                _secondaryButton(isChildSelected),
            ],
          ),
        ),
        floatingActionButton: keyboardIsVisible
            ? null
            : (isLast)
                ? _primaryButton(isChildSelected)
                : _secondaryButton(isChildSelected));
  }

  Widget _primaryButton(bool isChildSelected) {
    return FunButton(
      onTap: () => onDone(isChildSelected: isChildSelected),
      text: 'Done!',
      analyticsEvent: AnalyticsEvent(AmplitudeEvents.addMemberDoneClicked),
    );
  }

  Widget _secondaryButton(bool isChildSelected) {
    return FunButton.secondary(
      onTap: () {
        final member = addMember(isChildSelected: isChildSelected);
        if (member != null) {
          Navigator.push(
            context,
            FamilyMemberFormPage(
              index: widget.index + 1,
              totalCount: widget.totalCount,
              membersToCombine: [
                ...widget.membersToCombine,
                member,
              ],
            ).toRoute(context),
          );
        }
      },
      text: 'Add next member',
      rightIcon: FontAwesomeIcons.arrowRight,
      analyticsEvent: AnalyticsEvent(AmplitudeEvents.addMemberClicked),
    );
  }
}
