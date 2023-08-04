import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/recurring_donations/cancel/widgets/cancel_recurring_donation_confirmation_dialog.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
//import 'package:givt_app/features/recurring_donations/overview/widgets/create_recurring_donation_button.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donations_list.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class RecurringDonationsOverviewPage extends StatelessWidget {
  const RecurringDonationsOverviewPage({super.key});

  Future<void> _fetchRecurringDonations(BuildContext context) async {
    await context
        .read<RecurringDonationsCubit>()
        .fetchRecurringDonations(context.read<AuthCubit>().state.user.guid);
  }

  Future<void> _fetchRecurringInstances(
    BuildContext context,
    RecurringDonation selected,
  ) async {
    await context.read<RecurringDonationsCubit>().fetchRecurringInstances(
        context.read<RecurringDonationsCubit>().state
            as RecurringDonationsFetchedState,
        selected);
  }

  void _onCancelRecurringDonationPressed(
    BuildContext context,
    RecurringDonation recurringDonation,
  ) {
    showDialog<bool>(
      context: context,
      builder: (_) => CancelRecurringDonationConfirmationDialog(
        recurringDonation: recurringDonation,
      ),
    ).then((result) {
      if (result != null && result == true) {
        _fetchRecurringDonations(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          locals.menuItemRecurringDonation,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocConsumer<RecurringDonationsCubit, RecurringDonationsState>(
        listener: (context, state) {
          LoggingInfo.instance
              .info('recurring donations cubit state changed on $state');
          if (state is RecurringDonationsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  locals.somethingWentWrong,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is RecurringDonationsFetchingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final recurringDonations = <RecurringDonation>[];
          if (state is RecurringDonationsFetchedState) {
            recurringDonations.addAll(state.activeRecurringDonations);
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Hide inactive button
                // CreateRecurringDonationButton(
                //   onClick: () {},
                //   locals: locals,
                // ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.givtLightGray.withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: size.height * 0.76,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locals.menuItemRecurringDonation,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: AppTheme.givtBlue,
                        ),
                        const SizedBox(height: 10),
                        if (recurringDonations.isEmpty)
                          Column(
                            children: [
                              Text(
                                locals.emptyRecurringDonationList,
                              ),
                              SizedBox(
                                height: size.height * 0.5,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/givy_money.png',
                                    width: size.width * 0.5,
                                  ),
                                ),
                              )
                            ],
                          )
                        else
                          RecurringDonationsList(
                            height: size.height * 0.69,
                            recurringDonations: recurringDonations,
                            onOverview: (RecurringDonation recurringDonation) {
                              _fetchRecurringInstances(
                                context,
                                recurringDonation,
                              );
                            },
                            onCancel: (RecurringDonation recurringDonation) {
                              _onCancelRecurringDonationPressed(
                                context,
                                recurringDonation,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
