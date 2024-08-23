import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/widgets/child_or_parent_selector.dart';
import 'package:givt_app/features/children/add_member/widgets/family_member_form.dart';
import 'package:givt_app/features/children/add_member/widgets/smiley_counter.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';

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
  List<bool> selections = [true, false];
  List<Member> members = [];
  int _amount = 5;

  @override
  void initState() {
    super.initState();
  }

  bool addMember({bool isChildSelected = false}) {
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
      members
        ..addAll(widget.membersToCombine)
        ..add(newMember)
        ..toSet()
        ..toList();
      return true;
    }
    return false;
  }

  void pop() {}

  @override
  Widget build(BuildContext context) {
    final isLast = widget.index == widget.totalCount;
    final isChildSelected = selections[0];
    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Set up Family',
        leading: GenerosityBackButton(
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
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
                  onAmountChanged: (amount) {
                    setState(() {
                      _amount = amount;
                    });
                  },
                  isChildSelected: isChildSelected,
                ),
                const SizedBox(height: 40),
                const Spacer(),
                if (isLast)
                  GivtElevatedButton(
                    onTap: () {
                      // handle api call
                      if (addMember(isChildSelected: isChildSelected)) {
                        print('members added: ${members.length}');
                        for (final member in members) {
                          print(member.firstName);
                        }
                        showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (_) => BlocProvider(
                            create: (context) => AddMemberCubit(
                              getIt(),
                              getIt(),
                            ),
                            child: Builder(
                              builder: (context) {
                                return VPCPage(
                                  onReadyClicked: () {
                                    context.read<AddMemberCubit>()
                                      ..addAllMembers(members)
                                      ..createMember();
                                    Navigator.of(context).popUntil(
                                      (route) =>
                                          FamilyPages.childrenOverview.name ==
                                          route.settings.name,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ).then((value) {
                          // if (context.read<AddMemberCubit>().state.status ==
                          //     AddMemberStateStatus.loading) {
                          //   return;
                          // }
                          // context.read<AddMemberCubit>().dismissedVPC();
                        });
                      }
                    },
                    text: 'Done',
                    rightIcon: FontAwesomeIcons.exclamation,
                  )
                else
                  GivtElevatedSecondaryButton(
                    onTap: () {
                      if (addMember(isChildSelected: isChildSelected)) {
                        Navigator.push(
                          context,
                          FamilyMemberFormPage(
                            index: widget.index + 1,
                            totalCount: widget.totalCount,
                            membersToCombine: members,
                          ).toRoute(context),
                        );
                      }
                    },
                    text: 'Continue',
                    rightIcon: const Icon(FontAwesomeIcons.arrowRight),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
