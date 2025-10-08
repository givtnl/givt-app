import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_modal.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/platform_contribution/cubit/platform_contribution_cubit.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_organization.dart';
import 'package:givt_app/features/platform_contribution/domain/models/platform_contribution_settings.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

/// Main platform contribution screen
class PlatformContributionScreen extends StatefulWidget {
  const PlatformContributionScreen({super.key});

  @override
  State<PlatformContributionScreen> createState() =>
      _PlatformContributionScreenState();
}

class _PlatformContributionScreenState
    extends State<PlatformContributionScreen> {
  final PlatformContributionCubit _cubit = getIt();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: locals.platformContributionTitle,
        leading: GivtBackButtonFlat(
          onPressed: () async => _handleBackPressed(context),
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: _buildScaffold,
        onLoading: (context) => _buildLoadingScaffold(),
        onError: _buildErrorScaffold,
        onCustom: _handleCustom,
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    PlatformContributionSettings settings,
  ) {
    // Check if there are any organizations at all
    final hasOrganizations = settings.organizations.isNotEmpty;

    if (hasOrganizations) {
      // Show data state - list of organizations with their settings
      return _buildDataState(context, settings);
    } else {
      // Show empty state - no organizations available
      return _buildEmptyState(context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final locals = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FunIconGivy.happy(
          circleSize: 140,
        ),
        const SizedBox(height: 16),
        TitleMediumText(
          locals.platformContributionHelpLowerCosts,
          textAlign: TextAlign.center,
          color: FamilyAppTheme.neutralVariant40,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.platformContributionAims,
          textAlign: TextAlign.center,
          color: FamilyAppTheme.neutralVariant60,
        ),
      ],
    );
  }

  Widget _buildDataState(
    BuildContext context,
    PlatformContributionSettings settings,
  ) {
    final locals = context.l10n;
    return Column(
      children: [
        // Header text
        BodySmallText(
          locals.platformContributionManage,
          textAlign: TextAlign.center,
          color: FamilyAppTheme.neutralVariant40,
        ),
        const SizedBox(height: 8),
        // Organizations list with direct editing - show ALL organizations
        Expanded(
          child: ListView.builder(
            itemCount: settings.organizations.length,
            itemBuilder: (context, index) {
              final organization = settings.organizations[index];
              return _buildEditableOrganizationCard(context, organization);
            },
          ),
        ),
        // Save changes button
        FunButton(
          text: locals.platformContributionSaveChangesButton,
          onTap: settings.hasChanges ? _cubit.saveChanges : null,
          isDisabled: !settings.hasChanges,
          analyticsEvent: AmplitudeEvents.platformContributionSaveChangesClicked
              .toEvent(),
        ),
      ],
    );
  }

  Widget _buildEditableOrganizationCard(
    BuildContext context,
    PlatformContributionOrganization organization,
  ) {
    final locals = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FamilyAppTheme.neutralVariant95,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                CollectGroupType.getIconByType(organization.type),
                size: 20,
                color: FamilyAppTheme.primary30,
              ),
              const SizedBox(width: 12),
              // Organization name
              Expanded(
                child: TitleMediumText(
                  organization.name,
                  color: FamilyAppTheme.primary30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Toggle switch
              Switch(
                value: organization.isEnabled,
                onChanged: (isEnabled) {
                  _cubit.updateOrganizationToggle(
                    organizationId: organization.id,
                    isEnabled: isEnabled,
                  );
                },
              ),
            ],
          ),
          if (organization.isEnabled) ...[
            const SizedBox(height: 16),
            // Contribution level dropdown
            FunInputDropdown<PlatformContributionLevel>(
              value: organization.contributionLevel,
              items: PlatformContributionLevel.values,
              itemBuilder: (context, option) => Padding(
                padding: const EdgeInsets.only(left: 12),
                child: LabelLargeText(
                  _getContributionLevelText(locals, option),
                ),
              ),
              onChanged: (value) {
                _cubit.updateOrganizationContributionLevel(
                  organizationId: organization.id,
                  contributionLevel: value,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  String _getContributionLevelText(
    AppLocalizations locals,
    PlatformContributionLevel level,
  ) {
    switch (level) {
      case PlatformContributionLevel.mostPopular:
        return locals.platformContributionMostPopular;
      case PlatformContributionLevel.extraGenerous:
        return locals.platformContributionExtraGenerous;
    }
  }

  Widget _buildLoadingScaffold() {
    return const Center(
      child: CustomCircularProgressIndicator(),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, String? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 80,
          color: FamilyAppTheme.error50,
        ),
        const SizedBox(height: 16),
        TitleMediumText(
          error ?? 'An error occurred',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FunButton(
          text: 'Retry',
          onTap: _cubit.init,
          analyticsEvent: AmplitudeEvents.retryClicked.toEvent(),
        ),
      ],
    );
  }

  Future<void> _handleBackPressed(BuildContext context) async {
    final state = _cubit.state;

    if (state
            is DataState<
              PlatformContributionSettings,
              PlatformContributionCustom
            > &&
        state.data.hasChanges) {
      _cubit.showSaveChangesDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _handleCustom(BuildContext context, PlatformContributionCustom custom) {
    switch (custom) {
      case final ShowSaveChangesDialog _:
        _showSaveChangesDialog(context);
        break;
      case final HideSaveChangesDialog _:
        Navigator.of(context).pop();
        break;
      case final NavigateToSettings _:
        // Handle navigation if needed
        break;
    }
  }

  void _showSaveChangesDialog(BuildContext context) {
    final locals = context.l10n;

    FunModal(
      title: locals.platformContributionSaveChangesModalTitle,
      subtitle: locals.platformContributionSaveChangesModalBody,
      buttons: [
        FunButton(
          text: locals.platformContributionSaveChangesModalYesButton,
          onTap: () {
            _cubit.saveChanges();
            Navigator.of(context).pop(); // Close modal
            Navigator.of(context).pop(); // Go back
          },
          analyticsEvent: AmplitudeEvents.platformContributionSaveConfirmClicked
              .toEvent(),
        ),
        FunButton.secondary(
          text: locals.platformContributionSaveChangesModalNoButton,
          onTap: () {
            _cubit.discardChanges();
            Navigator.of(context).pop(); // Close modal
            Navigator.of(context).pop(); // Go back
          },
          analyticsEvent: AmplitudeEvents
              .platformContributionDiscardConfirmClicked
              .toEvent(),
        ),
      ],
    ).show(context);
  }
}
