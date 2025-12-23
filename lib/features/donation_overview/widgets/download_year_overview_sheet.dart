import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';

import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class DownloadYearOverviewSheet extends StatelessWidget {
  const DownloadYearOverviewSheet({
    required this.uiModel,
    required this.cubit,
    super.key,
  });

  final DonationOverviewUIModel uiModel;
  final DonationOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    String _overviewYearController = DateTime.now().year.toString();

    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;

    return FunBottomSheet(
      title: '',
      closeAction: () => context.pop(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BodyMediumText(
            '${locals.downloadYearOverviewByChoice} ${user.email}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          YearOfDonationsDropdown(
            donationYears: _getYears(uiModel),
            selectedYear: _getYears(uiModel).contains(_overviewYearController)
                ? _overviewYearController
                : _getYears(uiModel).first,
            onYearChanged: (String? newValue) {
              _overviewYearController = newValue!;
            },
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/images/givy_money.png',
            height: 160,
          ),
          const SizedBox(height: 32),
        ],
      ),
      primaryButton: FunButton(
        onTap: () {
          cubit.downloadYearlyOverview(
            year: _getYears(uiModel).contains(_overviewYearController)
                ? _overviewYearController
                : _getYears(uiModel).first,
          );
          context.pop();
        },
        text: locals.send,
        analyticsEvent: AnalyticsEventName.downloadAnnualOverviewClicked.toEvent(),
      ),
    );
  }

  List<String> _getYears(DonationOverviewUIModel uiModel) {
    final years = <String>{};
    for (final monthGroup in uiModel.monthlyGroups) {
      years.add(monthGroup.year.toString());
    }
    if (years.isEmpty) {
      years.add(DateTime.now().year.toString());
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  static void show(
    BuildContext context,
    DonationOverviewUIModel uiModel,
    DonationOverviewCubit cubit,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => DownloadYearOverviewSheet(
        uiModel: uiModel,
        cubit: cubit,
      ),
    );
  }
}

class YearOfDonationsDropdown extends StatelessWidget {
  const YearOfDonationsDropdown({
    required this.donationYears,
    required this.selectedYear,
    required this.onYearChanged,
    super.key,
  });

  final List<String> donationYears;
  final String selectedYear;
  final void Function(String?) onYearChanged;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DropdownButtonFormField<String>(
      validator: (value) {
        if (value == null) {
          return '';
        }
        return null;
      },
      value: selectedYear,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FamilyAppTheme.primary20,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FamilyAppTheme.primary20,
          ),
        ),
        errorStyle: TextStyle(
          height: 0,
        ),
      ),
      menuMaxHeight: size.height * 0.3,
      items: donationYears
          .map(
            (String year) => DropdownMenuItem(
              value: year,
              child: Text(
                year,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
          .toList(),
      onChanged: onYearChanged,
    );
  }
}
