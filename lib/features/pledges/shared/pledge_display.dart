import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

/// Display helpers for [Pledge] list UI.
abstract final class PledgeDisplay {
  static String formatAmount({
    required double amount,
    required String countryCode,
  }) {
    final currency = Util.getCurrencySymbol(countryCode: countryCode);
    final formatted = Util.formatNumberComma(
      amount,
      Country.fromCode(countryCode),
    );
    return '$currency$formatted';
  }

  static String formatFrequency(
    AppLocalizations locals,
    String frequencyString,
  ) {
    if (_displaysAsAllAtOnce(frequencyString)) {
      return locals.pledgesListCardSubtitleOnce('').trim();
    }

    final frequency = _parseFrequency(frequencyString);
    if (frequency == null) {
      return frequencyString;
    }
    return ExternalDonationFrequencyDropdown.frequencyLabel(
      locals,
      frequency,
    );
  }

  static String formatNextExecutionDate({
    required AppLocalizations locals,
    required Pledge pledge,
    required String locale,
  }) {
    final date = pledge.nextExecutionDateTime;
    if (date == null) {
      return '';
    }
    return locals.pledgesListNextUp(
      ApiDateTime.formatYMMMd(date, locale),
    );
  }

  static String buildCardTitle({
    required Pledge pledge,
    required List<Pledge> sectionPledges,
  }) {
    final hasDuplicatePledgeGroup = sectionPledges
            .where((item) => item.pledgeGroupName == pledge.pledgeGroupName)
            .length >
        1;

    if (hasDuplicatePledgeGroup) {
      return '${pledge.pledgeGroupName} · ${pledge.goalName}';
    }

    return pledge.pledgeGroupName;
  }

  static String buildGroupCardTitle(PledgeOverviewCard card) {
    return card.pledgeGroupName;
  }

  static String buildGroupCardSubtitle({
    required AppLocalizations locals,
    required PledgeOverviewCard card,
    required String countryCode,
    required String locale,
  }) {
    final amount = formatAmount(
      amount: card.totalAmount,
      countryCode: countryCode,
    );
    final frequency = card.sharedFrequency;

    if (frequency != null && _displaysAsAllAtOnce(frequency)) {
      return locals.pledgesListCardSubtitleOnce(amount);
    }

    if (frequency != null) {
      final frequencyLabel = formatFrequency(locals, frequency);
      final nextExecutionDate = card.earliestNextExecution;
      if (nextExecutionDate != null) {
        return locals.pledgesListCardSubtitleRecurring(
          frequencyLabel,
          amount,
          ApiDateTime.formatYMMMd(nextExecutionDate, locale),
        );
      }
      return '$frequencyLabel $amount';
    }

    return amount;
  }

  static GoalCardProgressUImodel? buildGroupCardProgress({
    required PledgeOverviewCard card,
    required String countryCode,
  }) {
    final target = card.totalTarget;
    if (target == null || target <= 0) {
      return null;
    }

    final paidAmount = card.totalPaid;
    final formattedPaid = formatAmount(
      amount: paidAmount,
      countryCode: countryCode,
    );
    final formattedGoal = formatAmount(
      amount: target,
      countryCode: countryCode,
    );

    return GoalCardProgressUImodel(
      amount: paidAmount,
      goalAmount: target.round().clamp(1, 999999999),
      totalAmount: target,
      displayText: '$formattedPaid / $formattedGoal',
    );
  }

  static String buildCardSubtitle({
    required AppLocalizations locals,
    required Pledge pledge,
    required String countryCode,
    required String locale,
  }) {
    final amount = formatAmount(
      amount: pledge.amount,
      countryCode: countryCode,
    );

    if (_displaysAsAllAtOnce(pledge.frequency)) {
      return locals.pledgesListCardSubtitleOnce(amount);
    }

    final frequencyLabel = formatFrequency(locals, pledge.frequency);
    final nextExecutionDate = pledge.nextExecutionDateTime;
    if (nextExecutionDate != null) {
      return locals.pledgesListCardSubtitleRecurring(
        frequencyLabel,
        amount,
        ApiDateTime.formatYMMMd(nextExecutionDate, locale),
      );
    }

    return '$frequencyLabel $amount';
  }

  static GoalCardProgressUImodel? buildCardProgress({
    required Pledge pledge,
    required String countryCode,
  }) {
    final goalAmount = pledge.goalAmount;
    final target = goalAmount != null && goalAmount > 0
        ? goalAmount
        : _displaysAsAllAtOnce(pledge.frequency)
            ? pledge.amount
            : null;
    if (target == null || target <= 0) {
      return null;
    }

    final paidAmount = pledge.paidAmount;
    final formattedPaid = formatAmount(
      amount: paidAmount,
      countryCode: countryCode,
    );
    final formattedGoal = formatAmount(
      amount: target,
      countryCode: countryCode,
    );

    return GoalCardProgressUImodel(
      amount: paidAmount,
      goalAmount: target.round().clamp(1, 999999999),
      totalAmount: target,
      displayText: '$formattedPaid / $formattedGoal',
    );
  }

  static String formatGoalAmountWithFrequency({
    required AppLocalizations locals,
    required PledgeGoal goal,
    required String countryCode,
  }) {
    final parts = parseGoalAmountFrequency(
      locals: locals,
      goal: goal,
      countryCode: countryCode,
    );
    if (parts.isAllAtOnce) {
      return parts.allAtOnceText!;
    }
    return '${parts.amount}${parts.unitSuffix}';
  }

  /// Amount and `/unit` parts for per-goal detail rows (Figma split styling).
  static PledgeGoalAmountFrequencyParts parseGoalAmountFrequency({
    required AppLocalizations locals,
    required PledgeGoal goal,
    required String countryCode,
  }) {
    final amount = formatAmount(amount: goal.amount, countryCode: countryCode);
    if (_displaysAsAllAtOnce(goal.frequency)) {
      return PledgeGoalAmountFrequencyParts(
        isAllAtOnce: true,
        allAtOnceText: locals.pledgesListCardSubtitleOnce(amount),
      );
    }

    final unit = formatFrequencyUnit(locals, goal.frequency);
    return PledgeGoalAmountFrequencyParts(
      amount: amount,
      unitSuffix: unit == null ? null : '/$unit',
    );
  }

  static String? formatFrequencyUnit(
    AppLocalizations locals,
    String frequencyString,
  ) {
    switch (frequencyString) {
      case 'Weekly':
        return locals.setupRecurringGiftWeek;
      case 'Monthly':
        return locals.setupRecurringGiftMonth;
      case 'Quarterly':
        return locals.setupRecurringGiftQuarter;
      case 'HalfYearly':
        return locals.setupRecurringGiftHalfYear;
      case 'Yearly':
        return locals.setupRecurringGiftYear;
      case 'Daily':
        return 'day';
      case 'None':
        return null;
      default:
        return null;
    }
  }

  static String formatGoalProgress({
    required double given,
    required double target,
    required String countryCode,
    required AppLocalizations locals,
  }) {
    final formattedGiven = formatAmount(amount: given, countryCode: countryCode);
    final formattedTarget = formatAmount(amount: target, countryCode: countryCode);
    return locals.pledgesDetailGoalProgress(formattedGiven, formattedTarget);
  }

  static String formatHistoryDate(DateTime date, String locale) {
    return DateFormat.MMMd(locale).format(date.toLocal());
  }

  static String formatHistoryDateLine(
    DateTime date,
    String locale, {
    required bool includeTime,
  }) {
    final datePart = formatHistoryDate(date, locale);
    if (!includeTime) {
      return datePart;
    }
    final time = formatHistoryTime(date);
    if (time != null) {
      return '$datePart $time';
    }
    return datePart;
  }

  static String? formatHistoryTime(DateTime date) {
    if (date.hour == 0 && date.minute == 0) {
      return null;
    }
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String buildCardDescription({
    required AppLocalizations locals,
    required Pledge pledge,
    required String countryCode,
    required String locale,
  }) {
    final parts = <String>[
      pledge.goalName,
      formatAmount(amount: pledge.amount, countryCode: countryCode),
      formatFrequency(locals, pledge.frequency),
    ];

    final nextExecution = formatNextExecutionDate(
      locals: locals,
      pledge: pledge,
      locale: locale,
    );
    if (nextExecution.isNotEmpty) {
      parts.add(nextExecution);
    }

    return parts.join(' · ');
  }

  static bool _displaysAsAllAtOnce(String frequencyString) {
    switch (frequencyString) {
      case 'Once':
      case 'OneTime':
      case 'Yearly':
        return true;
      default:
        return false;
    }
  }

  static ExternalDonationFrequency? _parseFrequency(String frequencyString) {
    switch (frequencyString) {
      case 'Once':
      case 'OneTime':
        return ExternalDonationFrequency.once;
      case 'Weekly':
        return ExternalDonationFrequency.weekly;
      case 'Monthly':
        return ExternalDonationFrequency.monthly;
      case 'Quarterly':
        return ExternalDonationFrequency.quarterly;
      case 'HalfYearly':
        return ExternalDonationFrequency.halfYearly;
      case 'Yearly':
        return ExternalDonationFrequency.yearly;
      default:
        return null;
    }
  }
}

class PledgeGoalAmountFrequencyParts {
  const PledgeGoalAmountFrequencyParts({
    this.amount,
    this.unitSuffix,
    this.isAllAtOnce = false,
    this.allAtOnceText,
  });

  final String? amount;
  final String? unitSuffix;
  final bool isAllAtOnce;
  final String? allAtOnceText;
}
