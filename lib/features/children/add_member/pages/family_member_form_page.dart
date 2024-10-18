import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_loading_page.dart';
import 'package:givt_app/features/children/add_member/widgets/child_or_parent_selector.dart';
import 'package:givt_app/features/children/add_member/widgets/family_member_form.dart';
import 'package:givt_app/features/children/add_member/widgets/member_counter.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/registration/widgets/avatar_selection_bottomsheet.dart';
import 'package:givt_app/features/registration/widgets/random_avatar.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/app_theme.dart';

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
  late AvatarsCubit avatars;

  @override
  void initState() {
    _amount = widget.showTopUp ? 5 : 0;
    avatars = getIt<AvatarsCubit>();

    super.initState();
  }

  Member? addMember({bool isChildSelected = false}) {
    if (_formKey.currentState!.validate()) {
      final avatar = avatars.state.getAvatarByKey(widget.index.toString());
      final newMember = isChildSelected
          ? Member(
              firstName: _nameController.text,
              age: int.parse(_ageController.text),
              dateOfBirth: dateOfBirth(),
              allowance: _amount,
              profilePictureURL: avatar.pictureURL,
              profilePictureName: avatar.fileName,
              type: ProfileType.Child,
            )
          : Member(
              firstName: _nameController.text,
              email: _emailController.text,
              profilePictureURL: avatar.pictureURL,
              profilePictureName: avatar.fileName,
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
    avatars.clear();
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
                MemberCounter(
                  totalCount: widget.totalCount,
                  index: widget.index,
                  otherMembersIcons: [
                    ...widget.membersToCombine.map(
                      (member) => _memberIcon(
                        member.profilePictureURL ?? '',
                        member.firstName ?? '',
                      ),
                    ),
                    _buildCurrentMemberIcon(context, avatars),
                  ],
                ),
                const SizedBox(height: 24),
                ChildOrParentSelector(
                  selections: selections,
                  onPressed: (int index) {
                    setState(() {
                      selections = [index == 0, index == 1];
                    });

                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                RandomAvatar(
                  id: widget.index.toString(),
                  onClick: () {
                    AvatarSelectionBottomsheet.show(
                      context,
                      widget.index.toString(),
                    );
                  },
                ),
                const SizedBox(height: 16),
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

  Widget _buildCurrentMemberIcon(BuildContext context, AvatarsCubit avatars) {
    return BlocBuilder<AvatarsCubit, AvatarsState>(
      bloc: avatars,
      builder: (context, state) {
        if (state.status != AvatarsStatus.loaded) {
          return Container(
            height: 32,
            width: 32,
            color: AppTheme.primary80,
          );
        }
        return _memberIcon(
          state.getAvatarByKey(widget.index.toString()).pictureURL,
          _nameController.text,
        );
      },
    );
  }

  Widget _memberIcon(String pictureURL, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SvgPicture.network(
            height: 32,
            width: 32,
            pictureURL,
            placeholderBuilder: (context) =>
                const CustomCircularProgressIndicator(),
          ),
          LabelMediumText(name),
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
