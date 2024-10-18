import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class MemberCounter extends StatefulWidget {
  const MemberCounter({
    required this.totalCount,
    this.displayFamily = true,
    this.otherMembersIcons = const [],
    this.index,
    super.key,
  });

  final int totalCount;
  final bool displayFamily;
  final List<Widget> otherMembersIcons;
  final int? index;

  @override
  State<MemberCounter> createState() => _MemberCounterState();
}

class _MemberCounterState extends State<MemberCounter> {
  @override
  Widget build(BuildContext context) {
    final avatarsCount = widget.index != null ? widget.index! : 0;
    final placeholdercount = widget.totalCount - avatarsCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.displayFamily) _buildFamilyIcons(context),
        ...widget.otherMembersIcons,
        ...List.generate(placeholdercount, (_) => _buildSmileyIcon()),
      ],
    );
  }

  Widget _buildFamilyIcons(BuildContext context) {
    final familyMembersIcons = <Widget>[];
    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        if (state.profiles.isEmpty) {
          return const SizedBox();
        }
        familyMembersIcons.clear();
        for (final profile in state.profiles) {
          familyMembersIcons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SvgPicture.network(
                    height: 32,
                    width: 32,
                    profile.pictureURL,
                  ),
                  LabelMediumText(profile.firstName),
                ],
              ),
            ),
          );
        }
        return Row(
          children: [
            ...familyMembersIcons,
          ],
        );
      },
    );
  }

  Widget _buildSmileyIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: defaultHero(width: 32, height: 32),
    );
  }

  @override
  void initState() {
    context.read<ProfilesCubit>().refresh();
    super.initState();
  }
}
