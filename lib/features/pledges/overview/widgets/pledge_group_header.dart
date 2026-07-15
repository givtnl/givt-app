import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/overview/cubit/pledges_overview_cubit.dart';

class PledgeGroupHeader extends StatelessWidget {
  const PledgeGroupHeader({
    required this.section,
    super.key,
  });

  final PledgeGroupSection section;

  @override
  Widget build(BuildContext context) {
    return TitleSmallText(section.groupName);
  }
}
