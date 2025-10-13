import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/cancel/widgets/cancel_recurring_donation_confirmation_dialog.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/pages/recurring_donations_overview_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecurringDonationDetailPage extends StatefulWidget {
  const RecurringDonationDetailPage({
    required this.recurringDonation,
    super.key,
  });

  final RecurringDonation recurringDonation;

  @override
  State<RecurringDonationDetailPage> createState() =>
      _RecurringDonationDetailPageState();
}

class _RecurringDonationDetailPageState
    extends State<RecurringDonationDetailPage> {
  late final RecurringDonationDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Set the recurring donation in the repository FIRST
    getIt<RecurringDonationDetailRepository>().setRecurringDonation(
      widget.recurringDonation,
    );

    // Then create and initialize the cubit
    _cubit = getIt<RecurringDonationDetailCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);

    return FunScaffold(
      appBar: FunTopAppBar.white(
        leading: GivtBackButtonFlat(
          onPressed: () async => context.pop(),
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, custom) {
          switch (custom) {
            case ManageDonation():
              // Navigate to manage donation page or show options
              _showManageOptions(context);
          }
        },
        onData: (context, uiModel) {
          if (uiModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: FamilyAppTheme.error80,
                  ),
                  const SizedBox(height: 16),
                  TitleMediumText(
                    locals.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BodyMediumText.opacityBlack50(
                    uiModel.error ?? '',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrganizationHeader(uiModel),
                      const SizedBox(height: 24),
                      _buildProgressSection(uiModel, context),
                      const SizedBox(height: 24),
                      _buildSummaryCards(uiModel, currency, context),
                      const SizedBox(height: 24),
                      _buildHistorySection(uiModel, currency, context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              // Manage button - all donations from /active endpoint are considered active
              _buildManageButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrganizationHeader(RecurringDonationDetailUIModel uiModel) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Organization icon
          const FaIcon(
            FontAwesomeIcons.church,
            size: 40,
            color: FamilyAppTheme.secondary30,
          ),
          const SizedBox(height: 8),
          // Organization name
          TitleMediumText(
            uiModel.organizationName.isNotEmpty 
                ? uiModel.organizationName 
                : 'Loading...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    RecurringDonationDetailUIModel uiModel,
    BuildContext context,
  ) {
    if (uiModel.progress == null) {
      // Don't show anything for unlimited donations
      return const SizedBox.shrink();
    }

    return FunProgressbar(
      currentProgress: uiModel.progress!.completed,
      total: uiModel.progress!.total,
      backgroundColor: FamilyAppTheme.neutralVariant95,
      textColor: FamilyAppTheme.primary20,
      progressColor: FamilyAppTheme.primary90,
      suffix: context.l10n.recurringDonationsDetailProgressSuffix,
    );
  }

  Widget _buildSummaryCards(
    RecurringDonationDetailUIModel uiModel,
    String currency,
    BuildContext context,
  ) {
    final auth = context.read<AuthCubit>().state;
    final country = Country.fromCode(auth.user.country);
    
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.moneyBillWave,
            value: '$currency${Util.formatNumberComma(uiModel.totalDonated, country)}',
            label: context.l10n.recurringDonationsDetailSummaryDonated,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.solidCalendar,
            value: _getTimeDisplay(uiModel, context),
            label: _getHelpingLabel(uiModel, context),
            endDateTag: uiModel.endDate,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
    DateTime? endDateTag,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FunTile(
          borderColor: FamilyAppTheme.neutralVariant80,
          backgroundColor: FamilyAppTheme.neutralVariant99,
          textColor: FamilyAppTheme.neutral30,
          iconColor: FamilyAppTheme.neutral30,
          iconData: icon,
          assetSize: 32,
          iconPath: '',
          analyticsEvent: AmplitudeEvents.recurringDonationEditClicked
              .toEvent(),
          isPressedDown: true,
          titleBig: value,
          subtitle: label,
        ),

        if (endDateTag != null)
          Positioned(
            top: -8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: FamilyAppTheme.highlight90,
                borderRadius: BorderRadius.circular(12),
              ),
              child: LabelSmallText(
                context.l10n.recurringDonationsDetailEndsTag(
                  _formatDate(endDateTag, context),
                ),
                color: FamilyAppTheme.highlight30,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHistorySection(
    RecurringDonationDetailUIModel uiModel,
    String currency,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMediumText(context.l10n.recurringDonationsDetailHistoryTitle),
        const SizedBox(height: 16),
        ...uiModel.history.map(
          (item) => _buildHistoryItem(item, currency, context),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    DonationHistoryItem item,
    String currency,
    BuildContext context,
  ) {
    final auth = context.read<AuthCubit>().state;
    final country = Country.fromCode(auth.user.country);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FamilyAppTheme.neutralVariant95,
          ),
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getStatusColor(item.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getStatusIcon(item.status),
              size: 16,
              color: _getStatusTextColor(item.status),
            ),
          ),
          const SizedBox(width: 12),
          // Amount and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(
                  '$currency${Util.formatNumberComma(item.amount, country)}',
                  color: FamilyAppTheme.primary40,
                ),
                LabelSmallText(
                  _formatDate(item.date, context),
                  color: FamilyAppTheme.neutralVariant50,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          // Status tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(item.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: LabelSmallText(
              _getStatusText(item.status, context),
              color: _getStatusTextColor(item.status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageButton(BuildContext context) {
    return FunButton.secondary(
      onTap: () => _cubit.onManageDonationPressed(),
      text: context.l10n.recurringDonationsDetailManageButton,
      analyticsEvent: AmplitudeEvents.recurringDonationManageClicked.toEvent(),
    );
  }

  Color _getStatusColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return FamilyAppTheme.secondary95;
      case DonationStatus.processed:
        return FamilyAppTheme.primary95;
      case DonationStatus.inprocess:
        return FamilyAppTheme.neutralVariant95;
    }
  }

  Color _getStatusTextColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return FamilyAppTheme.secondary40;
      case DonationStatus.processed:
        return FamilyAppTheme.primary30;
      case DonationStatus.inprocess:
        return FamilyAppTheme.highlight30;
    }
  }

  IconData _getStatusIcon(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return Icons.more_horiz;
      case DonationStatus.processed:
        return Icons.check;
      case DonationStatus.inprocess:
        return Icons.schedule;
    }
  }

  String _getStatusText(DonationStatus status, BuildContext context) {
    switch (status) {
      case DonationStatus.upcoming:
        return context.l10n.recurringDonationsDetailStatusUpcoming;
      case DonationStatus.processed:
        return context.l10n.recurringDonationsDetailStatusCompleted;
      case DonationStatus.inprocess:
        return context.l10n.recurringDonationsDetailStatusPending;
    }
  }

  String _getHelpingLabel(
    RecurringDonationDetailUIModel uiModel,
    BuildContext context,
  ) {
    // Always show "Helped" since we're showing total days from start until now
    return context.l10n.recurringDonationsDetailSummaryHelped;
  }

  String _getTimeDisplay(
    RecurringDonationDetailUIModel uiModel,
    BuildContext context,
  ) {
    final startDate = DateTime.parse(widget.recurringDonation.startDate);
    
    // Check if the recurring donation has ended (cancelled, completed, or past end date)
    if (uiModel.endDate != null && uiModel.endDate!.isBefore(DateTime.now())) {
      // For cancelled/completed donations, show days between start and last transaction
      final completedTransactions = uiModel.history
          .where((h) => h.status == DonationStatus.processed)
          .toList();
      
      if (completedTransactions.isNotEmpty) {
        // Find the last completed transaction
        final lastTransaction = completedTransactions
            .reduce((a, b) => a.date.isAfter(b.date) ? a : b);
        final daysHelped = lastTransaction.date.difference(startDate).inDays;
        // Ensure non-negative value
        final safeDaysHelped = daysHelped < 0 ? 0 : daysHelped;
        return context.l10n.recurringDonationsDetailTimeDisplayDays(
          safeDaysHelped.toString(),
        );
      } else {
        // Fallback: no completed transactions, show days from start to end date
        final daysHelped = uiModel.endDate!.difference(startDate).inDays;
        // Ensure non-negative value
        final safeDaysHelped = daysHelped < 0 ? 0 : daysHelped;
        return context.l10n.recurringDonationsDetailTimeDisplayDays(
          safeDaysHelped.toString(),
        );
      }
    } else {
      // For active donations, show days from start until now
      final now = DateTime.now();
      final daysHelped = now.difference(startDate).inDays;
      // Ensure non-negative value
      final safeDaysHelped = daysHelped < 0 ? 0 : daysHelped;
      return context.l10n.recurringDonationsDetailTimeDisplayDays(
        safeDaysHelped.toString(),
      );
    }
  }

  String _formatDate(DateTime date, BuildContext context) {
    final locale = Util.getLanguageTageFromLocale(context);
    return DateFormat.yMMMd(locale).format(date);
  }

  void _showManageOptions(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(context.l10n.recurringDonationsDetailEditDonation),
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.recurringDonationEditActionClicked,
                );
                Navigator.of(context).pop();
                // TODO: Navigate to edit page when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.l10n.recurringDonationsDetailEditComingSoon,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pause),
              title: Text(context.l10n.recurringDonationsDetailPauseDonation),
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.recurringDonationPauseActionClicked,
                );
                Navigator.of(context).pop();
                // TODO: Implement pause functionality when available
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.l10n.recurringDonationsDetailPauseComingSoon,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: Text(
                context.l10n.recurringDonationsDetailCancelDonation,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.recurringDonationCancelActionClicked,
                );
                // Show cancel confirmation dialog
                showDialog<bool>(
                  context: context,
                  builder: (context) =>
                      CancelRecurringDonationConfirmationDialog(
                        recurringDonation: widget.recurringDonation,
                      ),
                ).then((result) {
                  // If cancellation was successful, navigate back to overview
                  if (result == true && context.mounted) {
                    Navigator.of(context).push(
                      const RecurringDonationsOverviewPage().toRoute(context),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
