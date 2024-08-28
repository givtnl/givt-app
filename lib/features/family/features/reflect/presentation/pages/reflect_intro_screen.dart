import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class ReflectIntroScreen extends StatefulWidget {
  const ReflectIntroScreen({super.key});

  @override
  State<ReflectIntroScreen> createState() => _ReflectIntroScreenState();
}

class _ReflectIntroScreenState extends State<ReflectIntroScreen> {
  final _cubit = getIt<FamilyOverviewCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: FamilyScaffold(
        appBar: const TopAppBar(title: 'Reflect and share'),
        body: BlocConsumer<FamilyOverviewCubit, FamilyOverviewState>(
          builder: (BuildContext context, state) {
            return  Column(
              children: [
                const TitleMediumText(
                    'Build a family habit of reflection, sharing and gratitude.'),
               if(state is FamilyOverviewUpdatedState) const FamilyGoalCircle(),
                GivtElevatedButton(onTap: () {}, text: "Let's start"),
              ],
            );
          },
          listener: (BuildContext context, Object? state) {},
        ),
      ),
    );
  }
}
