import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/edit_avatar/bloc/edit_avatar_cubit.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_custom.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/looking_good_screen.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/locked_button_widget.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/widgets/locked_captain_message_widget.dart';
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
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class EditAvatarScreen extends StatefulWidget {
  const EditAvatarScreen({required this.userGuid, super.key});

  final String userGuid;

  @override
  State<EditAvatarScreen> createState() => _EditAvatarScreenState();
}

class _EditAvatarScreenState extends State<EditAvatarScreen> {
  final _cubit = getIt<EditAvatarCubit>();
  final TooltipController controller = TooltipController();

  @override
  void initState() {
    super.initState();
    _cubit.init(widget.userGuid);
  }

  @override
  void dispose() {
    controller.dispose();
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
    const options = ['Default', 'Customize'];

    return OverlayTooltipScaffold(
      controller: controller,
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
            if (data.mode == options[0])
              IconButton(
                onPressed: _cubit.saveAvatar,
                icon: const FaIcon(FontAwesomeIcons.check),
              ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            FunPrimaryTabs(
              options: options,
              selectedIndex: data.mode == options[0] ? 0 : 1,
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.avatarTabChanged,
              ),
              onPressed: _cubit.setMode,
            ),
            const SizedBox(height: 16),
            if (data.mode == options[0]) ..._getDefaultView(data),
            if (data.mode == options[1]) ..._getCustomView(data),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDefaultView(EditAvatarUIModel data) {
    return [
      Center(
        child: SvgPicture.asset(
          'assets/family/images/avatar/default/${data.avatarName}',
          height: 350,
        ),
      ),
      const SizedBox(height: 24),
      Expanded(
        child: SingleChildScrollView(
          child: _getDefaultAvatars(data),
        ),
      ),
    ];
  }

  List<Widget> _getCustomView(EditAvatarUIModel data) {
    return [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/family/images/avatar/custom/placeholder.svg',
              height: 350,
            ),
          ),
          if (data.lockMessageEnabled) const LockedCaptainMessageWidget(),
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Expanded(
        child: _getCustomTabs(),
      ),
    ];
  }

  Widget _getCustomTabs() {
    return FunSecondaryTabs(
      tabs: const [
        Tab(
          icon: FaIcon(FontAwesomeIcons.solidFaceSmile),
        ),
        Tab(
          icon: FaIcon(FontAwesomeIcons.scissors),
        ),
        Tab(
          icon: FaIcon(FontAwesomeIcons.mask),
        ),
        Tab(
          icon: FaIcon(FontAwesomeIcons.shirt),
        ),
      ],
      tabContents: [
        _getCustomItems(),
        _getCustomItems(),
        _getCustomItems(),
        _getCustomItems(),
      ],
    );
  }

  Widget _getCustomItems() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20, // Horizontal spacing
          mainAxisSpacing: 24, // Vertical spacing
        ),
        itemCount: 6,
        itemBuilder: (context, index) => LockedButtonWidget(
          onPressed: _cubit.lockedButtonClicked,
        ),
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

  void _navigateToLookingGoodScreen(
    BuildContext context,
    LookingGoodUIModel uiModel,
  ) {
    Navigator.of(context).push(
      LookingGoodScreen(uiModel: uiModel).toRoute(context),
    );
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
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.avatarSaved),
        ),
        FunTextButton(
          textColor: FamilyAppTheme.error30,
          rightIconSize: 0,
          onTap: () {
            _cubit.navigateBack(force: true);
            context.pop();
          },
          text: 'No, delete',
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.cancelClicked),
        )
      ],
    ).show(context);
  }
}
