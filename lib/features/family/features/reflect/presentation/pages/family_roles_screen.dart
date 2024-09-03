import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_roles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/reveal_secret_word.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/game_profile_item.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class FamilyRolesScreen extends StatefulWidget {
  const FamilyRolesScreen({super.key});

  @override
  State<FamilyRolesScreen> createState() => _FamilyRolesScreenState();
}

class _FamilyRolesScreenState extends State<FamilyRolesScreen> {
  final _cubit = getIt<FamilyRolesCubit>();
  final AppConfig _appConfig = getIt();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      minimumPadding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
      appBar: const TopAppBar(title: 'Your roles'),
      body: BaseStateConsumer<List<GameProfile>, dynamic>(
        cubit: _cubit,
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
                      childAspectRatio: 0.9,
                      crossAxisCount: 3,
                      children: createGridItems(
                        profiles.take(6).toList(),
                      ),
                    ),
                  ),
                  if (_appConfig.isTestApp)
                    GivtElevatedButton(
                      onTap: () {
                        _cubit.assignRolesForNextRound();
                      },
                      text: 'Test: assign roles for next round',
                    ),
                  GivtElevatedButton(
                      onTap: () {
                        Navigator.of(context)
                            .push(RevealSecretWordScreen().toRoute(context));
                      },
                      text: 'Start'),
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
