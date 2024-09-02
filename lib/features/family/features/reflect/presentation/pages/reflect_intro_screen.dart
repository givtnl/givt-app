import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_circle.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/family_selection_screen.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class ReflectIntroScreen extends StatefulWidget {
  const ReflectIntroScreen({super.key});

  @override
  State<ReflectIntroScreen> createState() => _ReflectIntroScreenState();
}

class _ReflectIntroScreenState extends State<ReflectIntroScreen> {
  final _cubit = FamilyOverviewCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.fetchFamilyProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: FamilyScaffold(
        appBar: const TopAppBar(title: 'Reflect and share'),
        body: BlocConsumer<FamilyOverviewCubit, FamilyOverviewState>(
          builder: (BuildContext context, state) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleMediumText(
                        'Build a family habit of reflection, sharing and gratitude',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    if (state is !FamilyOverviewUpdatedState)
                      const CustomCircularProgressIndicator(),
                    if (state is FamilyOverviewUpdatedState)
                      const FamilyGoalCircle(
                        icon: Icon(
                          FontAwesomeIcons.solidComments,
                          color: FamilyAppTheme.primary30,
                          size: 64,
                        ),
                      ),
                    const SizedBox(height: 64),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GivtElevatedButton(
                      onTap: () {
                        Navigator.of(context).push(
                            const FamilySelectionScreen().toRoute(context));
                      },
                      text: "Let's start"),
                ),
              ],
            );
          },
          listener: (BuildContext context, Object? state) {},
        ),
      ),
    );
  }
}