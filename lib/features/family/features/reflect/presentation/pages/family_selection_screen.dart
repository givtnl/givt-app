import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/background_audio/presentation/volume_bottomsheet.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/game_roles_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/animated_arc.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/arc.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/profile_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';

class FamilySelectionScreen extends StatefulWidget {
  const FamilySelectionScreen({super.key});

  @override
  State<FamilySelectionScreen> createState() => _FamilySelectionScreenState();
}

class _FamilySelectionScreenState extends State<FamilySelectionScreen> {
  FamilySelectionCubit cubit = getIt<FamilySelectionCubit>();
  List<GameProfile> selectedProfiles = <GameProfile>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.primary99,
      minimumPadding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      safeAreaBottom: false,
      appBar: FunTopAppBar(
        title: 'Who is playing?',
        leading: GivtBackButtonFlat(
          onPressedExt: () async {
            Navigator.of(context).pop();
          },
        ),
        systemNavigationBarColor: pulseColor,
        actions: const [
          LeaveGameButton(),
        ],
      ),
      body: BaseStateConsumer(
        cubit: cubit,
        onCustom: (context, custom) {
          switch (custom) {
            case final GoToPassThePhone data:
              Navigator.of(context).push(
                PassThePhone.toSuperhero(data.profile).toRoute(context),
              );
            case final GoToPassThePhoneAndReplace data:
              Navigator.of(context).pushReplacement(
                PassThePhone.toSuperhero(data.profile).toRoute(context),
              );
            // ignore: unused_local_variable
            case final ShowVolumeBottomsheet data:
              showVolumeBottomSheet(context);
          }
        },
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
                  profileGrid(
                    profiles.where((profile) => profile.isAdult).toList(),
                  ),
                  const SizedBox(height: 12),
                  profileGrid(
                    profiles
                        .where((profile) => profile.isChild)
                        .take(6)
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showVolumeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      builder: (context) {
        return VolumeBottomsheet(
          onReady: () => cubit.navigate(),
        );
      },
    );
  }

  Widget _seeRolesButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - 48,
        child: FunButton(
          onTap: () => cubit.rolesClicked(selectedProfiles),
          isDisabled: selectedProfiles.length < 2,
          text: 'See the rules',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.reflectAndShareSeeTheRulesClicked,
          ),
        ),
      ),
    );
  }

  Widget _selectedProfiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < selectedProfiles.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Semantics(
                identifier: selectedProfiles[i].pictureURL?.split('/').last,
                child: SvgPicture.network(
                  selectedProfiles[i].pictureURL!,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
        ],
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
      child: DragTarget<GameProfile>(
        onWillAcceptWithDetails: (details) {
          return true;
        },
        onAcceptWithDetails: (details) {
          // Only add once
          if (selectedProfiles.contains(details.data)) {
            return;
          }

          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.reflectAndShareMemberAdded,
            eventProperties: {
              'name': details.data.firstName,
            },
          );

          setState(() {
            selectedProfiles.add(details.data);
          });
        },
        builder: (
          BuildContext context,
          List<Object?> candidateData,
          List<dynamic> rejectedData,
        ) {
          return _dragWidget(context, candidateData);
        },
      ),
    );
  }

  final mainColor = FamilyAppTheme.stageColorPulse;
  final pulseColor = FamilyAppTheme.stageColorPodium;

  Widget _dragWidget(BuildContext context, List<Object?> candidateDate) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          left: -50,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedArc(
              diameter: MediaQuery.sizeOf(context).width + 100,
              color: _shouldHighlight(candidateDate) ? pulseColor : mainColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Arc(
            diameter: MediaQuery.sizeOf(context).width,
            color: _shouldHighlight(candidateDate) ? mainColor : pulseColor,
          ),
        ),
        Positioned(bottom: 96, child: _selectedProfiles()),
        _seeRolesButton(context),
      ],
    );
  }

  Widget profileGrid(List<GameProfile> profiles) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 36,
      runSpacing: 12,
      children: [
        for (var i = 0; i < profiles.length; i++)
          isSelected(profiles[i])
              ? getEmptyProfileItem()
              : ProfileItem(
                  profile: profiles[i],
                  size: 60,
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
          child: isSelected(profiles[i])
              ? getEmptyProfileItem()
              : ProfileItem(
                  profile: profiles[i],
                  size: 60,
                ),
        ),
      );
    }
    return gridItems;
  }

  bool isSelected(GameProfile profile) {
    return selectedProfiles.contains(profile);
  }

  Widget getEmptyProfileItem() {
    return Container(
      width: 60,
      height: 93,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  bool _shouldHighlight(List<Object?> candidateData) =>
      candidateData.isNotEmpty;
}
