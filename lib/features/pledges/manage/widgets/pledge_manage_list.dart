import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/detail/widgets/external_donation_manage_list_item.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/features/pledges/manage/models/pledge_manage_field.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/l10n/l10n.dart';

class PledgeManageList extends StatelessWidget {
  const PledgeManageList({
    required this.uiModel,
    required this.countryCode,
    required this.locale,
    required this.onFieldPressed,
    super.key,
  });

  final PledgeManageUIModel uiModel;
  final String countryCode;
  final String locale;
  final void Function({
    required PledgeManageField field,
    PledgeGoal? goal,
  })
  onFieldPressed;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state.user;
    final group = uiModel.group;
    final givingMethodType = group.goals.firstOrNull?.type ?? 'Online';

    return Column(
      children: [
        for (final goal in group.goals)
          _ManageListItem(
            isDisabled: uiModel.isSaving,
            child: ExternalDonationManageListItem(
              icon: FontAwesomeIcons.solidHeart,
              label: goal.goalName,
              value: PledgeDisplay.buildManageGoalSubtitle(
                locals: locals,
                goal: goal,
                countryCode: countryCode,
              ),
              analyticsEvent: AnalyticsEventName.pledgesManageGoalEditClicked
                  .toEvent(
                    parameters: {'goal_id': goal.goalId},
                  ),
              onTap: () => onFieldPressed(
                field: PledgeManageField.goalAmount,
                goal: goal,
              ),
            ),
          ),
        _ManageListItem(
          isDisabled: uiModel.isSaving,
          child: ExternalDonationManageListItem(
            icon: FontAwesomeIcons.arrowsRotate,
            label: locals.pledgesEditFrequencyLabel,
            value: PledgeDisplay.buildManageFrequencySubtitle(
              locals: locals,
              group: group,
              locale: locale,
            ),
            analyticsEvent: AnalyticsEventName.pledgesManageFrequencyEditClicked
                .toEvent(),
            onTap: () => onFieldPressed(field: PledgeManageField.frequency),
          ),
        ),
        _ManageListItem(
          isDisabled: uiModel.isSaving,
          child: ExternalDonationManageListItem(
            icon: FontAwesomeIcons.buildingColumns,
            label: locals.pledgesEditGivingMethodLabel,
            value: PledgeDisplay.buildGivingMethodSubtitle(
              locals: locals,
              pledgeType: givingMethodType,
              iban: auth.iban,
              accountNumber: auth.accountNumber,
            ),
            analyticsEvent: AnalyticsEventName
                .pledgesManageGivingMethodEditClicked
                .toEvent(),
            onTap: () => onFieldPressed(field: PledgeManageField.givingMethod),
          ),
        ),
      ],
    );
  }
}

class _ManageListItem extends StatelessWidget {
  const _ManageListItem({
    required this.isDisabled,
    required this.child,
  });

  final bool isDisabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: child,
      ),
    );
  }
}
