import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/cubit/donation_overview_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/donation_overview/models/donation_overview_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class DownloadYearOverviewSheet extends StatefulWidget {
  const DownloadYearOverviewSheet({
    required this.uiModel,
    required this.cubit,
    super.key,
  });

  final DonationOverviewUIModel uiModel;
  final DonationOverviewCubit cubit;

  @override
  State<DownloadYearOverviewSheet> createState() =>
      _DownloadYearOverviewSheetState();

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

class _DownloadYearOverviewSheetState extends State<DownloadYearOverviewSheet> {
  late final List<String> _years;
  late String _selectedYear;

  @override
  void initState() {
    super.initState();
    _years = _yearsFor(widget.uiModel);
    _selectedYear = _initialYear(_years, widget.uiModel.filters);
  }

  @override
  Widget build(BuildContext context) {
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
            donationYears: _years,
            selectedYear: _selectedYear,
            onYearChanged: (String? newValue) {
              if (newValue == null) {
                return;
              }
              setState(() => _selectedYear = newValue);
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
          widget.cubit.downloadYearlyOverview(year: _selectedYear);
          context.pop();
        },
        text: locals.send,
        analyticsEvent: AnalyticsEventName.downloadAnnualOverviewClicked
            .toEvent(),
      ),
    );
  }

  static List<String> _yearsFor(DonationOverviewUIModel uiModel) {
    final years = <String>{
      for (final monthGroup in uiModel.monthlyGroups)
        monthGroup.year.toString(),
    };
    final filterYear = _singleCalendarYear(uiModel.filters);
    if (filterYear != null) {
      years.add(filterYear);
    }
    if (years.isEmpty) {
      years.add(DateTime.now().year.toString());
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  static String _initialYear(
    List<String> years,
    DonationHistoryFilters filters,
  ) {
    final filterYear = _singleCalendarYear(filters);
    if (filterYear != null) {
      return filterYear;
    }
    final currentYear = DateTime.now().year.toString();
    if (years.contains(currentYear)) {
      return currentYear;
    }
    return years.first;
  }

  static String? _singleCalendarYear(DonationHistoryFilters filters) {
    final start = filters.startDate;
    final end = filters.endDate;
    if (start == null || end == null || start.year != end.year) {
      return null;
    }
    return start.year.toString();
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
