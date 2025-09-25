import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/manage_family/cubit/manage_family_cubit.dart';
import 'package:givt_app/features/manage_family/models/manage_family_custom.dart';
import 'package:givt_app/features/manage_family/models/manage_family_uimodel.dart';
import 'package:givt_app/features/manage_family/widgets/group_invites_section.dart';
import 'package:givt_app/features/manage_family/widgets/family_members_section.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/add_member_util.dart';

class ManageFamilyPage extends StatefulWidget {
  const ManageFamilyPage({super.key});

  @override
  State<ManageFamilyPage> createState() => _ManageFamilyPageState();
}

class _ManageFamilyPageState extends State<ManageFamilyPage> {
  late final ManageFamilyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ManageFamilyCubit>();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.neutral100,
      appBar: const FunTopAppBar(
        title: 'Manage Family',
        leading: GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer<ManageFamilyUIModel, ManageFamilyCustom>(
        cubit: _cubit,
        onLoading: (context) => const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onError: (context, message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleLargeText('Error: $message'),
              const SizedBox(height: 24),
              FunButton(
                onTap: () => _cubit.loadFamilyData(),
                text: 'Retry',
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.retryClicked,
                ),
              ),
            ],
          ),
        ),
        onData: _buildContent,
        onCustom: _handleCustomEvents,
      ),
      floatingActionButton: FunButton(
        onTap: () => _cubit.navigateToCreateInvite(),
        text: 'Invite Family Member',
        leftIcon: Icons.person_add,
        analyticsEvent: AnalyticsEvent(AmplitudeEvents.addMemberClicked),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ManageFamilyUIModel uiModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Family Members Section
          FamilyMembersSection(
            members: uiModel.members,
            onMemberOptions: (memberId) =>
                _cubit.showMemberOptionsDialog(memberId),
          ),
          const SizedBox(height: 32),
          // Group Invites Section
          GroupInvitesSection(
            invites: uiModel.groupInvites,
            onInviteTap: (groupId) => _cubit.showGroupInviteDialog(groupId),
            onAcceptInvite: (groupId) => _cubit.acceptGroupInvite(groupId),
            onDeclineInvite: (groupId) => _cubit.declineGroupInvite(groupId),
          ),
          const SizedBox(height: 100), // Space for floating action button
        ],
      ),
    );
  }

  void _handleCustomEvents(
    BuildContext context,
    ManageFamilyCustom custom,
  ) {
    switch (custom) {
      case NavigateToCreateInvite():
        // context.pushNamed(Pages.createFamilyInvite.name);
        AddMemberUtil.addMemberPushPages(context, existingFamily: true, adultOnly: true);
      case ShowGroupInviteDialog(groupId: final groupId):
        _showGroupInviteDetailsDialog(groupId);
      case ShowMemberOptionsDialog(memberId: final memberId):
        _showMemberOptionsDialog(memberId);
      case RefreshFamilyData():
        _cubit.loadFamilyData();
    }
  }


  void _showGroupInviteDetailsDialog(String groupId) {
    // For now, just show a placeholder dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FamilyAppTheme.neutral100,
        surfaceTintColor: Colors.transparent,
        title: const TitleMediumText(
          'Group Invite Details',
          color: FamilyAppTheme.primary20,
        ),
        content: const BodyMediumText(
          'Group invite details will be implemented in a future update.',
          color: FamilyAppTheme.neutral50,
        ),
        actions: [
          FunButton(
            onTap: () => Navigator.of(context).pop(),
            text: 'OK',
            analyticsEvent: AnalyticsEvent(AmplitudeEvents.okClicked),
          ),
        ],
      ),
    );
  }

  void _showMemberOptionsDialog(String memberId) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FamilyAppTheme.neutral100,
        surfaceTintColor: Colors.transparent,
        title: const TitleMediumText(
          'Member Options',
          color: FamilyAppTheme.primary20,
        ),
        content: const BodyMediumText(
          'Member options will be implemented in a future update.',
          color: FamilyAppTheme.neutral50,
        ),
        actions: [
          FunButton(
            onTap: () => Navigator.of(context).pop(),
            text: 'OK',
            analyticsEvent: AnalyticsEvent(AmplitudeEvents.okClicked),
          ),
        ],
      ),
    );
  }
}
