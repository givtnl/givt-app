import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/animated_arc.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/arc.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/profile_item.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class FamilySelectionScreen extends StatefulWidget {
  const FamilySelectionScreen({super.key});

  @override
  State<FamilySelectionScreen> createState() => _FamilySelectionScreenState();
}

class _FamilySelectionScreenState extends State<FamilySelectionScreen> {
  var cubit = getIt<FamilySelectionCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      minimumPadding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
      appBar: const TopAppBar(title: 'Who is playing?'),
      body: BaseStateConsumer<List<GameProfile>, dynamic>(
        cubit: cubit,
        onLoading: (context) =>
            const Center(child: CircularProgressIndicator()),
        onData: (context, profiles) => Stack(
          children: [
            Align(alignment: Alignment.bottomCenter, child: _totalDragTarget()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Center(child: TitleMediumText('Drag to add players')),
                  const SizedBox(height: 20),
                  createAdultGrid(
                    profiles.where((profile) => profile.isAdult).toList(),
                  ),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 0.9,
                      crossAxisCount: 3,
                      children: createGridItems(
                        profiles
                            .where((profile) => profile.isChild)
                            .take(6)
                            .toList(),
                      ),
                    ),
                  ),
                  GivtElevatedButton(onTap: () {}, text: 'See roles'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalDragTarget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _dragTarget(),
      ],
    );
  }

  Widget _dragTarget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            return true;
          },
          onAcceptWithDetails: (details) {
            setState(() {
              // _draggedOnChurch.add(details.data);
            });
            // widget.onDonationDraggedOnChurch?.call();
          },
          builder: (BuildContext context, List<Object?> candidateData,
              List<dynamic> rejectedData) {
            return _dragWidget(context, candidateData);
          },
        ));
  }

  Widget _dragWidget(BuildContext context, List<Object?> candidateDate) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          left: -50,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedArc(
              diameter: MediaQuery.sizeOf(context).width + 100,
              color: _shouldHighlight(candidateDate)
                  ? FamilyAppTheme.secondary80.withOpacity(0.5)
                  : FamilyAppTheme.secondary98,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Arc(
            diameter: MediaQuery.sizeOf(context).width,
            color: _shouldHighlight(candidateDate)
                ? FamilyAppTheme.secondary95.withOpacity(0.5)
                : FamilyAppTheme.secondary95,
          ),
        ),
      ],
    );
  }

  Widget createAdultGrid(List<GameProfile> profiles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < profiles.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProfileItem(profile: profiles[i]),
          ),
      ],
    );
  }

  List<Widget> createGridItems(List<GameProfile> profiles) {
    final gridItems = <Widget>[];
    for (var i = 0; i < profiles.length; i++) {
      gridItems.add(
        GestureDetector(
          onTap: () {},
          child: ProfileItem(
            profile: profiles[i],
          ),
        ),
      );
    }
    return gridItems;
  }

  bool _shouldHighlight(List<Object?> candidateData) =>
      candidateData.isNotEmpty;
}
