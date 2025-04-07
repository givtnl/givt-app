import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/edit_avatar/bloc/edit_avatar_cubit.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_custom.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/looking_good_screen.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/locked_button_widget.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/locked_captain_message_widget.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/unlocked_color_widget.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/unlocked_item_widget.dart';
import 'package:givt_app/features/family/features/unlocked_badge/presentation/widgets/unlocked_badge_widget.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/helpers/color_helper.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_secondary_tabs.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class EditAvatarScreen extends StatefulWidget {
  const EditAvatarScreen({required this.userGuid, super.key});

  static const options = ['Default', 'Customize'];

  final String userGuid;

  @override
  State<EditAvatarScreen> createState() => _EditAvatarScreenState();
}

class _EditAvatarScreenState extends State<EditAvatarScreen>
    with TickerProviderStateMixin {
  final _cubit = getIt<EditAvatarCubit>();
  final TooltipController _tooltipController = TooltipController();
  late TabController _tabController;
  List<Color> bodyColors = [
    const Color(0xFF703E3D),
    const Color(0xFF8E4B26),
    const Color(0xFFA7674A),
    const Color(0xFFE99D67),
    const Color(0xFFF4A27F),
    const Color(0xFFFFC7BA),
    const Color(0xFFFECBA8),
    const Color(0xFFFFE3D8),
    const Color(0xFFFAE366),
    const Color(0xFFDAB9FF),
    const Color(0xFF6FF6F7),
    const Color(0xFF7EFAB5),
  ];

  List<Color> hairColors = [
    const Color(0xFF282A25),
    const Color(0xFF8F4F23),
    const Color(0xFFFFDF8D),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: Features.tabsOrderOfFeatures.length,
      vsync: this,
    );
    _tabController.addListener(() {
      _cubit.manualUnlockBadge(
        Features.tabsOrderOfFeatures[_tabController.index],
      );
    });
    _cubit.init(widget.userGuid);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tooltipController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onInitial: _onLoading, // Initial Loading State
      onLoading: _onLoading, // Loading State when saving the avatar
      onCustom: _onCustom,
      onData: _onData,
    );
  }

  Widget _onLoading(BuildContext context) {
    return const FunScaffold(
      canPop: false,
      appBar: FunTopAppBar(
        title: 'Your avatar',
      ),
      body: CustomCircularProgressIndicator(),
    );
  }

  void _onCustom(BuildContext context, EditAvatarCustom custom) {
    switch (custom) {
      case NavigateToProfile():
        context.pop();
      case ShowSaveOnBackDialog():
        _showSaveOnBackDialog(context);
      case NavigateToLookingGoodScreen():
        _navigateToLookingGoodScreen(context, custom.uiModel);
    }
  }

  Widget _onData(
    BuildContext context,
    EditAvatarUIModel data,
  ) {
    return OverlayTooltipScaffold(
      controller: _tooltipController,
      overlayColor: Colors.transparent,
      builder: (context) => FunScaffold(
        safeAreaBottom: false,
        minimumPadding: EdgeInsets.zero,
        appBar: FunTopAppBar(
          title: 'Your avatar',
          leading: GivtBackButtonFlat(
            onPressed: _cubit.navigateBack,
          ),
          actions: [
            if (data.isFeatureUnlocked ||
                data.mode == EditAvatarScreen.options[0])
              IconButton(
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.saveAvatarClicked,
                  );
                  _cubit.saveAvatar();
                },
                icon: const FaIcon(FontAwesomeIcons.check),
              ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Stack(
              children: [
                FunPrimaryTabs(
                  options: EditAvatarScreen.options,
                  selectedIndex:
                      data.mode == EditAvatarScreen.options[0] ? 0 : 1,
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.avatarTabChanged,
                  ),
                  onPressed: (Set<String> options) {
                    _cubit.setMode(options);
                    if (options.first == EditAvatarScreen.options[1]) {
                      _cubit.manualUnlockBadge(
                        Features.tabsOrderOfFeatures[_tabController.index],
                      );
                    }
                  },
                ),
                if (data.mode == EditAvatarScreen.options[0])
                  Positioned(
                    right: 24 - (12 / 2),
                    top: 0,
                    child: UnlockedBadgeWidget(
                      featureId: Features.profileEditAvatarButton,
                      profileId: data.userId,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (data.mode == EditAvatarScreen.options[0])
              ..._getDefaultView(data),
            if (data.mode == EditAvatarScreen.options[1])
              ..._getCustomView(data),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDefaultView(EditAvatarUIModel data) {
    return [
      Expanded(
        child: SvgPicture.asset(
          'assets/family/images/avatar/default/${data.avatarName}',
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: 320,
        child: SingleChildScrollView(
          child: _getDefaultAvatars(data),
        ),
      ),
    ];
  }

  List<Widget> _getCustomView(EditAvatarUIModel uiModel) {
    return [
      Expanded(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (!uiModel.isFeatureUnlocked)
              Center(
                child: SvgPicture.asset(
                  'assets/family/images/avatar/custom/placeholder.svg',
                ),
              ),
            if (uiModel.isFeatureUnlocked)
              ...FunAvatar.customAvatarWidgetsList(
                uiModel.customAvatarUIModel,
                fit: BoxFit.contain,
              ),
            if (uiModel.lockMessageEnabled) const LockedCaptainMessageWidget(),
          ],
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 320,
        child: _getCustomTabs(uiModel),
      ),
    ];
  }

  Widget _getCustomTabs(EditAvatarUIModel uiModel) {
    return FunSecondaryTabs(
      controller: _tabController,
      onTap: (index) =>
          _cubit.manualUnlockBadge(Features.tabsOrderOfFeatures[index]),
      tabs: [
        Tab(
          icon: UnlockedBadgeWidget(
            offset: 3,
            featureId: Features.tabsOrderOfFeatures[0],
            profileId: uiModel.userId,
            child: const FaIcon(FontAwesomeIcons.solidFaceSmile),
          ),
        ),
        Tab(
          icon: UnlockedBadgeWidget(
            offset: 3,
            featureId: Features.tabsOrderOfFeatures[1],
            profileId: uiModel.userId,
            child: const FaIcon(FontAwesomeIcons.scissors),
          ),
        ),
        Tab(
          icon: UnlockedBadgeWidget(
            offset: 3,
            featureId: Features.tabsOrderOfFeatures[2],
            profileId: uiModel.userId,
            child: const FaIcon(FontAwesomeIcons.mask),
          ),
        ),
        Tab(
          icon: UnlockedBadgeWidget(
            offset: 3,
            featureId: Features.tabsOrderOfFeatures[3],
            profileId: uiModel.userId,
            child: const FaIcon(FontAwesomeIcons.shirt),
          ),
        ),
      ],
      tabContents: [
        _getCustomItems(uiModel.bodyItems, isColors: uiModel.isFeatureUnlocked),
        _getCustomHairItems(
          uiModel,
          isFeatureUnlocked: uiModel.isFeatureUnlocked,
        ),
        _getCustomItems(uiModel.maskItems),
        _getCustomItems(uiModel.suitItems),
      ],
    );
  }

  Widget _getCustomHairItems(
    EditAvatarUIModel uiModel, {
    bool isFeatureUnlocked = false,
  }) {
    final items = uiModel.hairItems;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, isFeatureUnlocked ? 8 : 28, 24, 16),
      child: Column(
        children: [
          if (isFeatureUnlocked)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: hairColors.map((color) {
                final index = hairColors.indexOf(color);
                return UnlockedColorWidget(
                  size: 48,
                  color: color,
                  uiModel: UnlockedItem(
                    type: 'HairColor',
                    index: index,
                    isSelected: uiModel.customAvatarUIModel.hairColor ==
                        colorToHex(color),
                  ),
                  onPressed: _cubit.onUnlockedItemClicked,
                );
              }).toList(),
            ),
          if (isFeatureUnlocked) const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20, // Horizontal spacing
              mainAxisSpacing: 24, // Vertical spacing
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is LockedItem) {
                return LockedButtonWidget(
                  onPressed: _cubit.lockedButtonClicked,
                );
              } else {
                return UnlockedItemWidget(
                  uiModel: item as UnlockedItem,
                  recolor: uiModel.customAvatarUIModel.hairColor != null
                      ? colorFromHex(uiModel.customAvatarUIModel.hairColor!)
                      : null,
                  replacePlaceholders: true,
                  onPressed: _cubit.onUnlockedItemClicked,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _getCustomItems(
    List<EditAvatarItemUIModel> items, {
    bool isColors = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isColors ? 4 : 3,
          crossAxisSpacing: 20, // Horizontal spacing
          mainAxisSpacing: 24, // Vertical spacing
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is LockedItem) {
            return LockedButtonWidget(
              onPressed: _cubit.lockedButtonClicked,
            );
          } else {
            if (isColors) {
              return UnlockedColorWidget(
                color: bodyColors[index],
                uiModel: item as UnlockedItem,
                onPressed: _cubit.onUnlockedItemClicked,
              );
            } else {
              return UnlockedItemWidget(
                uiModel: item as UnlockedItem,
                onPressed: _cubit.onUnlockedItemClicked,
              );
            }
          }
        },
      ),
    );
  }

  Widget _getDefaultAvatars(EditAvatarUIModel data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16, // Horizontal spacing
          mainAxisSpacing: 24, // Vertical spacing
        ),
        itemCount: 10,
        itemBuilder: (context, index) => _getGridItem(context, index, data),
      ),
    );
  }

  Widget? _getGridItem(
    BuildContext context,
    int index,
    EditAvatarUIModel data,
  ) {
    final heroNumber = index + 1;
    final avatarName = 'Hero$heroNumber.svg';
    return GestureDetector(
      onTap: () => _cubit.setAvatar(avatarName),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FunAvatar.hero(avatarName),
          if (data.avatarName == avatarName)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: FamilyAppTheme
                      .primary80, // Border color for selected avatar
                  width: 8, // Border width
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _navigateToLookingGoodScreen(
    BuildContext context,
    LookingGoodUIModel uiModel,
  ) async {
    await Navigator.of(context).push(
      LookingGoodScreen(uiModel: uiModel).toRoute(context),
    );
    if (context.mounted) {
      context.pop();
    }
  }

  void _showSaveOnBackDialog(BuildContext context) {
    FunModal(
      icon: FunIcon.mask(),
      title: 'Save avatar?',
      subtitle: 'Any edits that you made to your avatar will be saved',
      buttons: [
        FunButton(
          text: 'Yes',
          onTap: () {
            _cubit.saveAvatar();
            context.pop();
          },
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.saveAvatarYesClicked),
        ),
        FunTextButton(
          textColor: FamilyAppTheme.error30,
          rightIconSize: 0,
          onTap: () {
            _cubit.navigateBack(force: true);
            context.pop();
          },
          text: 'No, delete',
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.saveAvatarNoClicked),
        ),
      ],
    ).show(context);
  }
}
