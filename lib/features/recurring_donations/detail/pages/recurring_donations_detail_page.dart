import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/detailed_recurring_donations_cubit.dart';
import 'package:givt_app/features/recurring_donations/detail/models/recurring_donation_detail.dart';
import 'package:givt_app/features/recurring_donations/detail/widgets/detail_list_item.dart';
import 'package:givt_app/features/recurring_donations/detail/widgets/detail_year_separator.dart';
import 'package:givt_app/features/recurring_donations/detail/widgets/upcoming_detail_item.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/widgets/donation_type_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class RecurringDonationsDetailPage extends StatelessWidget {
  const RecurringDonationsDetailPage(
      {required this.recurringDonation, super.key});
  final RecurringDonation recurringDonation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.read<AuthCubit>().state.user;
    final userCountry = Country.fromCode(user.country);
    final locals = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          recurringDonation.collectGroup.orgName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          _buildAppBarItem(
              context: context,
              icon: const Icon(Icons.info_rounded),
              child: const DonationTypeExplanationSheet())
        ],
      ),
      body: BlocConsumer<DetailedRecurringDonationsCubit,
          DetailedRecurringDonationsState>(
        listener: (context, state) {
          if (state is DetailedRecurringDonationsError) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.unknownError,
                content: state.error,
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DetailedRecurringDonationsLoading) {
            return const CircularProgressIndicator();
          }
          final recurringDonationsDetails = <RecurringDonationDetail>[];
          if (state is DetailedInstancesFetched) {
            recurringDonationsDetails.addAll(state.instances);
          }
          return Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: AppTheme.givtGrayf3f3f3,
            child: Column(
              children: [
                if (state is DetailedInstancesFetched)
                  SizedBox(
                    height: size.height * 0.89,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          UpcomingRecurringDonation(
                            upcoming: DetailInstanceItem(
                              size: size,
                              context: context,
                              userCountry: userCountry,
                              detail: _getUpcomingDonation(
                                lastInstance: recurringDonationsDetails.first,
                                recurringDonation: recurringDonation,
                                isGiftAidEnabled: user.isGiftAidEnabled,
                              ),
                            ),
                          ),
                          ..._getInstancesList(
                            context: context,
                            instances: recurringDonationsDetails,
                            userCountry: userCountry,
                            size: size,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  RecurringDonationDetail _getUpcomingDonation({
    required RecurringDonationDetail lastInstance,
    required RecurringDonation recurringDonation,
    required bool isGiftAidEnabled,
  }) {
    final nextTime =
        recurringDonation.getNextDonationDate(lastInstance.timestamp);
    final upcoming = RecurringDonationDetail(
      timestamp: nextTime,
      donationId: '1111',
      amount: int.parse(recurringDonation.amountPerTurn.toString()),
      status: 1,
      isGiftAidEnabled: isGiftAidEnabled,
    );
    return upcoming;
  }

  List<Widget> _getInstancesList({
    required List<RecurringDonationDetail> instances,
    required Size size,
    required BuildContext context,
    required Country userCountry,
  }) {
    int? currentYear;
    final finalList = <Widget>[];
    for (final obj in instances) {
      if (currentYear == null || obj.timestamp.year != currentYear) {
        // Add a year banner widget whenever the year changes
        finalList.add(YearBanner(obj.timestamp.year.toString()));
        currentYear = obj.timestamp.year;
      }

      // Add the date widget to the final list
      finalList.add(
        DetailInstanceItem(
          size: size,
          context: context,
          userCountry: userCountry,
          detail: obj,
        ),
      );
    }
    return finalList;
  }

  Widget _buildAppBarItem({
    required BuildContext context,
    required Widget child,
    required Icon icon,
    Color? color,
  }) {
    return Visibility(
      visible: true,
      child: IconButton(
        icon: icon,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: color ?? AppTheme.givtBlue,
          builder: (context) =>
              Container(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }
}
