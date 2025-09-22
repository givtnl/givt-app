import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/eu_profile_selection/cubit/eu_profile_selection_cubit.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile_selection_custom.dart';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile_selection_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:go_router/go_router.dart';

class EuProfileSelectionPage extends StatefulWidget {
  const EuProfileSelectionPage({
    super.key,
    this.initialAmount,
    this.code,
    this.afterGivingRedirection,
    this.navigateTo,
    this.given,
    this.retry,
  });

  final double? initialAmount;
  final String? code;
  final String? afterGivingRedirection;
  final String? navigateTo;
  final bool? given;
  final bool? retry;

  @override
  State<EuProfileSelectionPage> createState() => _EuProfileSelectionPageState();
}

class _EuProfileSelectionPageState extends State<EuProfileSelectionPage> {
  EuProfileSelectionCubit _cubit = getIt();
  @override
  void initState() {
    super.initState();
    _cubit.init();
    _cubit.loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.neutral100,
      body:
          BaseStateConsumer<
            EuProfileSelectionUIModel,
            EuProfileSelectionCustom
          >(
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
                    onTap: () => _cubit.loadProfiles(),
                    text: 'Retry',
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.retryClicked,
                    ),
                  ),
                ],
              ),
            ),
            onData: _buildNetflixStyleProfileSelection,
            onCustom: (context, custom) {
              switch (custom) {
                case NavigateToProfile(profileId: final profileId):
                  _navigateToHome(profileId);
                case ShowAddProfileDialog():
                  _onAddProfile();
              }
            },
          ),
    );
  }

  Widget _buildNetflixStyleProfileSelection(
    BuildContext context,
    EuProfileSelectionUIModel uiModel,
  ) {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 40),
              const Center(
                child: TitleLargeText(
                  "Who's giving today?",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: BodyMediumText(
                  'Choose a profile to continue',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),

              // Profile Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate width for 2 tiles per row with spacing
                    final availableWidth = constraints.maxWidth;
                    final spacing = 20.0;
                    final tileWidth = (availableWidth - spacing) / 2;

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: uiModel.profiles.map((profile) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: tileWidth,
                            ),
                            child: _buildProfileCard(
                              context,
                              profile,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    EuProfile profile,
  ) {
    return FunTile(
      borderColor: FamilyAppTheme.neutral80,
      backgroundColor: FamilyAppTheme.neutral100,
      textColor: FamilyAppTheme.primary20,
      iconPath: profile.avatar ?? '',
      iconColor: FamilyAppTheme.primary40,
      assetSize: 80,
      analyticsEvent: AnalyticsEvent(AmplitudeEvents.profilePressed),
      onTap: () => _onProfileSelected(profile),
      titleMedium: profile.name,
      subtitle: profile.email,
      mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _onProfileSelected(EuProfile profile) {
    _cubit
      ..selectProfile(profile.id)
      ..setActiveProfile(profile.id)
      ..navigateToProfile(profile.id);
  }

  void _navigateToHome(String profileId) {
    context.goNamed(
      'HOME',
      queryParameters: {
        if (widget.initialAmount != null)
          'amount': widget.initialAmount.toString(),
        if (widget.code != null) 'code': widget.code!,
        if (widget.afterGivingRedirection != null)
          'afterGivingRedirection': widget.afterGivingRedirection!,
        if (widget.navigateTo != null) 'page': widget.navigateTo!,
        if (widget.given == true) 'given': 'true',
        if (widget.retry == true) 'retry': 'true',
        'selectedProfileId': profileId,
      },
    );
  }

  void _onAddProfile() {
    // For now, just show a placeholder dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FamilyAppTheme.neutral100,
        surfaceTintColor: Colors.transparent,
        title: const TitleMediumText(
          'Add Profile',
          color: FamilyAppTheme.primary20,
        ),
        content: const BodyMediumText(
          'Profile creation will be implemented in a future update.',
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
