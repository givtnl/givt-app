import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_roles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reflection_rule_superhero_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/rule_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class FamilyRolesScreen extends StatefulWidget {
  const FamilyRolesScreen({super.key});

  @override
  State<FamilyRolesScreen> createState() => _FamilyRolesScreenState();
}

class _FamilyRolesScreenState extends State<FamilyRolesScreen> {
  final _cubit = getIt<FamilyRolesCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      minimumPadding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
      appBar: FunTopAppBar(
        title: 'Your roles',
        leading: (_cubit.isFirstRound()) ? const GivtBackButtonFlat() : null,
        actions: const [
          LeaveGameButton(),
        ],
      ),
      body: BaseStateConsumer<List<GameProfile>, GameProfile>(
        cubit: _cubit,
        onCustom: (context, superhero) {
          if (_cubit.isFirstRound()) {
            Navigator.of(context).push(
              RuleScreen.toSuperhero(superhero).toRoute(context),
              // ReflectionRuleSuperheroScreen(
              //   superhero: superhero,
              // ).toRoute(context),
            );
            return;
          }

          Navigator.of(context).pushReplacement(
            PassThePhone.toSuperhero(superhero).toRoute(context),
          );
        },
        onLoading: (context) =>
            const Center(child: CircularProgressIndicator()),
        onData: (context, profiles) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 0.85,
                      crossAxisCount: 3,
                      children: createGridItems(
                        profiles.take(9).toList(),
                      ),
                    ),
                  ),
                  FunButton(
                    onTap: _cubit.onClickStart,
                    text: 'Start',
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.reflectAndShareStartClicked,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createGridItems(List<GameProfile> profiles) {
    final gridItems = <Widget>[];
    for (var i = 0; i < profiles.length; i++) {
      gridItems.add(
        GestureDetector(
          onTap: () {},
          child: GameProfileItem(
            profile: profiles[i],
          ),
        ),
      );
    }
    return gridItems;
  }
}
