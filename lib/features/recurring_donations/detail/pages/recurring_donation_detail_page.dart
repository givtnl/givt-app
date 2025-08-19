import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/cancel/widgets/cancel_recurring_donation_confirmation_dialog.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

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
                      if (uiModel.hasProgress) _buildProgressSection(uiModel),
                      const SizedBox(height: 24),
                      _buildSummaryCards(uiModel, currency),
                      const SizedBox(height: 24),
                      _buildHistorySection(uiModel, currency),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              // Manage button always at bottom
              _buildManageButton(),
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
            uiModel.organizationName,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(RecurringDonationDetailUIModel uiModel) {
    if (uiModel.progress == null) return const SizedBox.shrink();

    return FunProgressbar(
      currentProgress: uiModel.progress!.completed,
      total: uiModel.progress!.total,
      backgroundColor: FamilyAppTheme.neutralVariant95,
      textColor: FamilyAppTheme.primary20,
      progressColor: FamilyAppTheme.primary90,
      suffix: 'donations',
    );
  }

  Widget _buildSummaryCards(
    RecurringDonationDetailUIModel uiModel,
    String currency,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.moneyBillWave,
            value: '$currency${uiModel.totalDonated.toStringAsFixed(0)}',
            label: 'Donated',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.solidCalendar,
            value: _getTimeDisplay(uiModel),
            label: _getHelpingLabel(uiModel),
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
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.recurringDonationsClicked,
          ),
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
                'Ends ${_formatDate(endDateTag)}',
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleMediumText('History'),
        const SizedBox(height: 16),
        ...uiModel.history.map((item) => _buildHistoryItem(item, currency)),
      ],
    );
  }

  Widget _buildHistoryItem(DonationHistoryItem item, String currency) {
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
                  '$currency${item.amount.toStringAsFixed(0)}',
                  color: FamilyAppTheme.primary40,
                ),
                LabelSmallText(
                  _formatDate(item.date),
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
              _getStatusText(item.status),
              color: _getStatusTextColor(item.status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageButton() {
    return FunButton.secondary(
      onTap: () => _cubit.onManageDonationPressed(),
      text: 'Manage donation',
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.recurringDonationsClicked,
      ),
    );
  }

  Color _getStatusColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return FamilyAppTheme.secondary95;
      case DonationStatus.completed:
        return FamilyAppTheme.primary95;
      case DonationStatus.pending:
        return FamilyAppTheme.highlight50;
    }
  }

  Color _getStatusTextColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return FamilyAppTheme.secondary40;
      case DonationStatus.completed:
        return FamilyAppTheme.primary30;
      case DonationStatus.pending:
        return FamilyAppTheme.highlight30;
    }
  }

  IconData _getStatusIcon(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return Icons.more_horiz;
      case DonationStatus.completed:
        return Icons.check;
      case DonationStatus.pending:
        return Icons.schedule;
    }
  }

  String _getStatusText(DonationStatus status) {
    switch (status) {
      case DonationStatus.upcoming:
        return 'Upcoming';
      case DonationStatus.completed:
        return 'Completed';
      case DonationStatus.pending:
        return 'Pending';
    }
  }

  String _getHelpingLabel(RecurringDonationDetailUIModel uiModel) {
    // Check if the recurring donation has ended (either cancelled, finished, or past end date)
    if (uiModel.endDate != null && uiModel.endDate!.isBefore(DateTime.now())) {
      return 'Helped';
    }
    return 'Helping';
  }

  String _getTimeDisplay(RecurringDonationDetailUIModel uiModel) {
    if (uiModel.endDate != null && uiModel.endDate!.isBefore(DateTime.now())) {
      // For completed recurring donations, show total days helped
      final startDate = DateTime.parse(widget.recurringDonation.startDate);
      final endDate = uiModel.endDate!;
      final daysHelped = endDate.difference(startDate).inDays;
      return '$daysHelped days';
    } else {
      // For active recurring donations, show remaining time
      return uiModel.remainingTime;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getShortMonthName(date.month)} ${date.year}';
  }

  String _getShortMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  void _showManageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit donation'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit page when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit functionality coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pause),
              title: const Text('Pause donation'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement pause functionality when available
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pause functionality coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text(
                'Cancel donation',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pop();
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
                    context.pop();
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
