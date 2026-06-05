import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/detail/widgets/stop_recording_modal.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class ExternalDonationDetailPage extends StatefulWidget {
  const ExternalDonationDetailPage({
    required this.donation,
    super.key,
  });

  final ExternalDonation donation;

  @override
  State<ExternalDonationDetailPage> createState() =>
      _ExternalDonationDetailPageState();
}

class _ExternalDonationDetailPageState extends State<ExternalDonationDetailPage> {
  late final ExternalDonationDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ExternalDonationDetailCubit>();
    _cubit.init(widget.donation);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);

    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: GivtBackButtonFlat(
          onPressed: () async => Navigator.of(context).pop(),
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, custom) {
          switch (custom) {
            case ShowStopRecordingModal():
              StopRecordingModal.show(
                context,
                onConfirm: _cubit.confirmStopRecording,
              );
            case StopRecordingSucceeded():
              context.pop(true);
            case StopRecordingFailed():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.somethingWentWrong),
                ),
              );
          }
        },
        onData: (context, uiModel) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrganizationHeader(context, uiModel.donation.description),
                      const SizedBox(height: 24),
                      if (uiModel.isRecurring) ...[
                        _buildSummaryCards(uiModel, currency, context),
                        const SizedBox(height: 24),
                        _buildHistorySection(uiModel, currency, context),
                      ] else
                        _buildOneOffSummary(uiModel, currency, context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              if (uiModel.isRecurring && uiModel.isActive)
                _buildStopButton(context),
            ],
          );
        },
        onError: (context, error) {
          final locals = context.l10n;
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
                if (error != null && error.isNotEmpty)
                  BodyMediumText.opacityBlack50(
                    error,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrganizationHeader(
    BuildContext context,
    String organizationName,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.handHoldingHeart,
            size: 40,
            color: FamilyAppTheme.secondary30,
          ),
          const SizedBox(height: 8),
          TitleMediumText(
            organizationName,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          FunTag(
            text: context.l10n.externalDonationsCreatePreviewTypeTag,
            variant: FunTagVariant.accent,
            iconData: FontAwesomeIcons.arrowsRotate,
            iconSize: 12,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildOneOffSummary(
    ExternalDonationDetailUIModel uiModel,
    String currency,
    BuildContext context,
  ) {
    final auth = context.read<AuthCubit>().state;
    final country = Country.fromCode(auth.user.country);
    final date = uiModel.donation.startDateTime;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.moneyBillWave,
            value:
                '$currency${Util.formatNumberComma(uiModel.totalDonated, country)}',
            label: context.l10n.recurringDonationsDetailSummaryDonated,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.solidCalendar,
            value: ExternalDonationDisplay.formatDate(
              date,
              Util.getLanguageTageFromLocale(context),
            ),
            label: context.l10n.externalDonationsDetailOneOffDate,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    ExternalDonationDetailUIModel uiModel,
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
            value:
                '$currency${Util.formatNumberComma(uiModel.totalDonated, country)}',
            label: context.l10n.recurringDonationsDetailSummaryDonated,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: FontAwesomeIcons.solidCalendar,
            value: _formatGivingDuration(uiModel.givingDuration, context),
            label: uiModel.isActive
                ? context.l10n.externalDonationsDetailSummaryGiving
                : context.l10n.recurringDonationsDetailSummaryHelped,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return FunTile(
      borderColor: FamilyAppTheme.neutralVariant80,
      backgroundColor: FamilyAppTheme.neutralVariant99,
      textColor: FamilyAppTheme.neutral30,
      iconColor: FamilyAppTheme.neutral30,
      iconData: icon,
      assetSize: 32,
      iconPath: '',
      analyticsEvent: AnalyticsEventName.externalDonationsDetailSummaryViewed
          .toEvent(),
      isPressedDown: true,
      titleBig: value,
      subtitle: label,
    );
  }

  Widget _buildHistorySection(
    ExternalDonationDetailUIModel uiModel,
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
    ExternalDonationHistoryItem item,
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.isUpcoming
                  ? FamilyAppTheme.secondary95
                  : FamilyAppTheme.primary95,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              item.isUpcoming ? Icons.more_horiz : Icons.check,
              size: 16,
              color: item.isUpcoming
                  ? FamilyAppTheme.secondary40
                  : FamilyAppTheme.primary30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMediumText(
                  '$currency${Util.formatNumberComma(item.amount, country)}',
                  color: FamilyAppTheme.primary40,
                ),
                LabelSmallText(
                  ExternalDonationDisplay.formatDate(
                    item.date,
                    Util.getLanguageTageFromLocale(context),
                  ),
                  color: FamilyAppTheme.neutralVariant50,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopButton(BuildContext context) {
    return FunButton(
      onTap: _cubit.onStopRecordingPressed,
      text: context.l10n.externalDonationsDetailStopButton,
      variant: FunButtonVariant.secondary,
      analyticsEvent: AnalyticsEventName.externalDonationsStopClicked.toEvent(),
    );
  }

  String _formatGivingDuration(
    GivingDuration? duration,
    BuildContext context,
  ) {
    if (duration == null) {
      return '';
    }
    final count = duration.value.toString();
    final singular = duration.value == 1;
    return switch (duration.unit) {
      GivingDurationUnit.days => singular
          ? context.l10n.recurringDonationsDetailTimeDisplayDay(count)
          : context.l10n.recurringDonationsDetailTimeDisplayDays(count),
      GivingDurationUnit.months => singular
          ? context.l10n.recurringDonationsDetailTimeDisplayMonth(count)
          : context.l10n.recurringDonationsDetailTimeDisplayMonths(count),
      GivingDurationUnit.years => singular
          ? context.l10n.recurringDonationsDetailTimeDisplayYear(count)
          : context.l10n.recurringDonationsDetailTimeDisplayYears(count),
    };
  }
}
