import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app/features/family/features/history/history_logic/history_cubit.dart';
import 'package:givt_app/features/family/features/history/models/allowance.dart';
import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/allowance_item_widget.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/donation_item_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final childId = context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = context.read<HistoryCubit>();
    final size = MediaQuery.of(context).size;
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (historyCubit.state.status != HistroryStatus.loading) {
          // Scrolled to end of list try to fetch more data
          historyCubit.fetchHistory(childId);
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
                    if (state.history[index].type == HistoryTypes.allowance) {
                      return AllowanceItemWidget(
                        allowance: state.history[index] as Allowance,
                      );
                    }
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: DonationItemWidget(
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
