import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app/features/family/features/history/history_logic/history_cubit.dart';
import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/features/history/models/donation_item_uimodel.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';
import 'package:givt_app/features/family/features/history/models/income.dart';
import 'package:givt_app/features/family/features/history/models/income_item_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/donation_item_widget.dart';
import 'package:givt_app/features/family/shared/widgets/income_item_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final childid = context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = context.read<HistoryCubit>();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (historyCubit.state.status != HistroryStatus.loading) {
          // Scrolled to end of list try to fetch more data
          historyCubit.fetchHistory(childid);
        }
      }
    });
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state.status == HistroryStatus.loading && state.history.isEmpty) {
          return const CustomCircularProgressIndicator();
        }
        if (state.status == HistroryStatus.error) {
          return Center(
            child: Text(state.error),
          );
        }
        // Display List of donations and allowances in descending date order
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  itemCount: state.history.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (state.history[index].type != HistoryTypes.donation) {
                      return IncomeItemWidget(
                          uimodel: IncomeItemUIModel(
                        income: state.history[index] as Income,
                      ));
                    }
                    return DonationItemWidget(
                      uimodel: DonationItemUIModel(
                        donation: state.history[index] as Donation,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 1,
                    height: 1,
                    endIndent: 20,
                    indent: 20,
                  ),
                ),
                if (state.status == HistroryStatus.loading &&
                    state.history.isNotEmpty)
                  const CustomCircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
