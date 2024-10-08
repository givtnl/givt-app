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
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class FamilyMemberFormPage extends StatefulWidget {
  const FamilyMemberFormPage({
    required this.index,
    required this.totalCount,
    required this.membersToCombine,
    this.showTopUp = false,
    super.key,
  });

  final int index;
  final int totalCount;
  final List<Member> membersToCombine;
  final bool showTopUp;

  @override
  State<FamilyMemberFormPage> createState() => _FamilyMemberFormPageState();
}

class _FamilyMemberFormPageState extends State<FamilyMemberFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  List<bool> selections = [true, false];
  late int _amount;

  @override
  void initState() {
    _amount = widget.showTopUp ? 5 : 0;
    super.initState();
  }

  Member? addMember({bool isChildSelected = false}) {
    if (_formKey.currentState!.validate()) {
      final newMember = isChildSelected
          ? Member(
              firstName: _nameController.text,
              age: int.parse(_ageController.text),
              dateOfBirth: dateOfBirth(),
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

  DateTime dateOfBirth() {
    final age = int.parse(_ageController.text);
    final currentYear = DateTime.now().year;
    return DateTime(currentYear - age, 7); //july 1st, mid-year
  }

  void onDone({bool isChildSelected = false}) {
    final member = addMember(isChildSelected: isChildSelected);

    if (member != null) {
      final members = [
        ...widget.membersToCombine,
        member,
      ];
      submitMembersAndNavigate(members: members);
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
    return FunScaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Set up Family',
        leading: const GivtBackButtonFlat(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmileyCounter(
                  totalCount: widget.totalCount,
                  index: widget.index,
                ),
                const SizedBox(height: 40),
                ChildOrParentSelector(
                  selections: selections,
                  onPressed: (int index) {
                    setState(() {
                      selections = [index == 0, index == 1];
                    });

                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 24),
                FamilyMemberForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  ageController: _ageController,
                  allowanceAmount: _amount,
                  showTopUp: widget.showTopUp,
                  onAmountChanged: (amount) {
                    setState(() {
                      _amount = amount;
                    });
                  },
                  isChildSelected: isChildSelected,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                if (isLast)
                  _primaryButton(isChildSelected)
                else
                  _secondaryButton(isChildSelected),
              ],
            ),
          ),
        ],
      ),
    );
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
              showTopUp: widget.showTopUp,
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
