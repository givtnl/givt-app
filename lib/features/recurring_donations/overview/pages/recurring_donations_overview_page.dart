import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donation_item.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class RecurringDonationsOverviewPage extends StatefulWidget {
  const RecurringDonationsOverviewPage({super.key});

  @override
  State<RecurringDonationsOverviewPage> createState() =>
      _RecurringDonationsOverviewPageState();
}

class _RecurringDonationsOverviewPageState
    extends State<RecurringDonationsOverviewPage> {
  RecurringDonation? selectedRecurringDonation;

  @override
  void initState() {
    super.initState();
    context
        .read<RecurringDonationsCubit>()
        .fetchRecurringDonations(context.read<AuthCubit>().state.user.guid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          //TODO: POEditor
          'Recurring donations',
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
                content: const Text(
                  //TODO: POEditor
                  'Cannot fetch recurring donations. Please try again later',
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //TODO: POEditor
                              'Schedule your',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              //TODO: POEditor
                              'recurring donation',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.givtGraycece.withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: size.height * 0.76,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //TODO: POEditor
                          'Recurring donations',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: size.height * 0.69,
                          child: SingleChildScrollView(
                            child: Column(
                              children: recurringDonations
                                  .map(
                                    (recurringDonation) =>
                                        RecurringDonationItem(
                                      recurringDonation: recurringDonation,
                                      isExtended: selectedRecurringDonation ==
                                          recurringDonation,
                                      onTap: () {
                                        setState(() {
                                          selectedRecurringDonation =
                                              selectedRecurringDonation ==
                                                      recurringDonation
                                                  ? null
                                                  : recurringDonation;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
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
