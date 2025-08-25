import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_custom.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/donation_overview/widgets/widgets.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:sticky_headers/sticky_headers.dart';

class DonationOverviewPage extends StatefulWidget {
  const DonationOverviewPage({
    super.key,
  });

  @override
  State<DonationOverviewPage> createState() => _DonationOverviewPageState();
}

class _DonationOverviewPageState extends State<DonationOverviewPage> {
  late final DonationOverviewCubit _cubit;
  late final String country;
  final TooltipController _tooltipController = TooltipController();

  @override
  void initState() {
    super.initState();

    country = context.read<AuthCubit>().state.user.country;
    _cubit = getIt<DonationOverviewCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onData: _buildScaffold,
      onLoading: (context) => _buildLoadingScaffold(),
      onError: _buildErrorScaffold,
    );
  }

  Widget _buildScaffold(BuildContext context, DonationOverviewUIModel uiModel) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;

    if (uiModel.donations.isEmpty) {
      return _buildEmptyScaffold(context);
    }

    return OverlayTooltipScaffold(
      controller: _tooltipController,
      overlayColor: Colors.transparent,
      builder: (context) => FunScaffold(
        minimumPadding: EdgeInsets.zero,
        safeAreaBottom: false,
        appBar: FunTopAppBar.white(
          title: locals.historyTitle,
          leading: const GivtBackButtonFlat(),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowDownLong),
              onPressed: () {
                DownloadYearOverviewSheet.show(context, uiModel, _cubit);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Donations list with monthly grouping
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _cubit.refreshDonations();
                  unawaited(
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.retryClicked,
                    ),
                  );
                },
                child: ListView.builder(
                  itemCount: uiModel.monthlyGroups.length,
                  itemBuilder: (context, index) {
                    final monthGroup = uiModel.monthlyGroups[index];

                    // Get donation groups for this month
                    final monthDonationGroups = uiModel.donationGroups.where((
                      group,
                    ) {
                      if (group.timeStamp == null) return false;
                      return group.timeStamp!.year == monthGroup.year &&
                          group.timeStamp!.month == monthGroup.month;
                    }).toList();

                    return StickyHeader(
                      header: _buildMonthHeader(
                        context,
                        monthGroup,
                        user.country,
                      ),
                      content: Column(
                        children: monthDonationGroups.map((donationGroup) {
                          return Column(
                            children: [
                              DonationListItem(
                                donationGroup: donationGroup,
                                onDelete: () => _cubit.showDeleteConfirmation(
                                  donationGroup.donations
                                      .map((d) => d.id)
                                      .toList(),
                                ),
                                onTap: () => _cubit.showDonationDetails(
                                  donationGroup.donations.first.id,
                                ),
                                analyticsEvent: AnalyticsEvent(
                                  AmplitudeEvents.seeDonationHistoryPressed,
                                ),
                                tooltipController: _tooltipController,
                              ),
                              const Divider(
                                height: 0,
                                color: FamilyAppTheme.neutralVariant95,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader(
    BuildContext context,
    MonthlyGroup monthGroup,
    String country,
  ) {
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: FamilyAppTheme.primary95, // Light green for monthly header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleSmallText(
            monthGroup.displayName,
            color: FamilyAppTheme.primary20,
          ),
          TitleSmallText(
            '$currencySymbol ${Util.formatNumberComma(
              monthGroup.totalAmount,
              Country.fromCode(country),
            )}',
            color: FamilyAppTheme.primary20,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyScaffold(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      appBar: FunTopAppBar(
        title: locals.historyTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleMediumText(
                locals.historyIsEmpty,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Icon(
                Icons.history,
                size: 80,
                color: FamilyAppTheme.neutralVariant80, // Light grey
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return const FunScaffold(
      body: Center(
        child: CustomCircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, String? error) {
    return FunScaffold(
      appBar: FunTopAppBar(
        title: context.l10n.historyTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: FamilyAppTheme.error50, // Error color
              ),
              const SizedBox(height: 16),
              TitleMediumText(
                error ?? 'An error occurred',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _cubit.refreshDonations();
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.retryClicked,
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCustom(BuildContext context, DonationOverviewCustom custom) {
    switch (custom) {
      case final ShowDeleteConfirmation event:
        _showDeleteConfirmation(context, event.ids);
      case final ShowDonationDetails event:
        // TODO: Navigate to donation details page
        break;
      case final DonationDeleted event:
        // TODO: Handle donation deleted
        break;
      case final DonationDeleteFailed event:
        _showErrorMessage(context, event.error);
      case final ShowSuccessMessage event:
        _showSuccessMessage(context, event.message);
      case final ShowErrorMessage event:
        _showErrorMessage(context, event.error);
    }
  }

  void _showDeleteConfirmation(BuildContext context, List<int> ids) {
    final isGroup = ids.length > 1;
    final message = isGroup
        ? 'Are you sure you want to delete this donation group (${ids.length} donations)?'
        : 'Are you sure you want to delete this donation?';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const TitleMediumText('Delete Donation'),
        content: BodyMediumText(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cubit.deleteDonation(ids);
            },
            style: TextButton.styleFrom(
              foregroundColor: FamilyAppTheme.error50,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDonationDetails(BuildContext context, int donationId) {
    // TODO: Implement donation details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Donation details for ID: $donationId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FamilyAppTheme.primary98,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FamilyAppTheme.error50,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
