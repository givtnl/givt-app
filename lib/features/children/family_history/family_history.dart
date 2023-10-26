import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/features/children/family_history/widgets/allowance_item_widget.dart';
import 'package:givt_app/features/children/family_history/widgets/donation_item_widget.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class FamilyHistory extends StatelessWidget {
  const FamilyHistory({required this.children, super.key});
  final List<Profile> children;
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final historyCubit = context.read<FamilyHistoryCubit>();
    final size = MediaQuery.sizeOf(context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (historyCubit.state.status != HistroryStatus.loading) {
          // Scrolled to end of list try to fetch more data
          historyCubit.fetchHistory();
        }
      }
    });
    final locals = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
          child: Text(
            locals.childHistoryAllGivts,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        SizedBox(
          height: size.height * 0.60,
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
              return Stack(children: [
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
                        donation: state.history[index] as ChildDonation,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return getDivider(state, index);
                  },
                ),
                if (state.status == HistroryStatus.loading &&
                    historyCubit.state.pageNr > 1)
                  Positioned(
                    bottom: 20,
                    left: size.width * 0.5 - 20,
                    child: const CircularProgressIndicator(),
                  )
              ]);
            },
          ),
        ),
      ],
    );
  }

  Widget getDivider(FamilyHistoryState state, int index) {
    if (state.history[index].type == HistoryTypes.donation) {
      final holder = state.history[index] as ChildDonation;
      final nextIndex = index + 1;

      if (nextIndex < state.history.length &&
          state.history[nextIndex].type == HistoryTypes.donation) {
        final next = state.history[nextIndex] as ChildDonation;
        if (next.state == DonationState.pending) {
          return const Divider(
            thickness: 0,
            height: 0,
            color: Colors.transparent,
            endIndent: 20,
            indent: 20,
          );
        }
      }

      final thickness = (holder.state == DonationState.pending) ? 0 : 1;
      final height = (holder.state == DonationState.pending) ? 0 : 1;
      final color = (holder.state == DonationState.pending)
          ? Colors.transparent
          : AppTheme.givtGraycece;

      return Divider(
        thickness: thickness.toDouble(),
        height: height.toDouble(),
        color: color,
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
  }
}
