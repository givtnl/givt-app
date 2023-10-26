import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_history/family_history_logic/family_history_cubit.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/features/children/family_history/widgets/allowance_item_widget.dart';
import 'package:givt_app/features/children/family_history/widgets/donation_item_widget.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

class FamilyHistory extends StatelessWidget {
  const FamilyHistory({required this.children, super.key});
  final List<Profile> children;
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final childId = children.first.id;
    //context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = context.read<FamilyHistoryCubit>();
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
    return SizedBox(
      height: size.height * 0.7,
      child: BlocBuilder<FamilyHistoryCubit, FamilyHistoryState>(
        builder: (context, state) {
          if (state.status == HistroryStatus.loading &&
              historyCubit.state.pageNr < 2) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HistroryStatus.error) {
            return Center(
              child: Text(state.error),
            );
          }
          // Display List of donations and allowances in descending date order
          return ListView.separated(
              padding: EdgeInsets.zero,
              controller: scrollController,
              itemCount: state.history.length,
              itemBuilder: (BuildContext context, int index) {
                if (state.history[index].type == HistoryTypes.allowance) {
                  return AllowanceItemWidget(
                      allowance: state.history[index] as Allowance);
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: DonationItemWidget(
                      donation: state.history[index] as ChildDonation),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (state.history[index].type == HistoryTypes.donation) {
                  final holder = state.history[index] as ChildDonation;
                  final double thickness =
                      (holder.state == DonationState.pending) ? 0 : 1;
                  final double height =
                      (holder.state == DonationState.pending) ? 0 : 1;

                  return Divider(
                    thickness: thickness,
                    height: height,
                    color: Colors.transparent,
                    endIndent: 20,
                    indent: 20,
                  );
                } else {
                  return const Divider(
                    thickness: 1,
                    height: 1,
                    endIndent: 20,
                    indent: 20,
                  );
                }
              });
        },
      ),
    );
  }
}
