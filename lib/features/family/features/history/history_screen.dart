import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/features/history/models/donation_item_uimodel.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';
import 'package:givt_app/features/family/features/history/models/income.dart';
import 'package:givt_app/features/family/features/history/models/income_item_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/content/donation_item_widget.dart';
import 'package:givt_app/features/family/shared/widgets/content/income_item_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final childid = context.read<ProfilesCubit>().state.activeProfile.id;
    final historyCubit = getIt<HistoryCubit>();

    scrollController.addListener(() {
      // Load more data when user scrolls to the bottom of the list
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (historyCubit.state.status != HistoryStatus.loading) {
          historyCubit.fetchHistory(childid);
        }
      }
    });

    return FunScaffold(
      appBar:
          const FunTopAppBar(title: 'My givts', leading: GivtBackButtonFlat()),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        bloc: historyCubit,
        builder: (context, state) {
          // Display loading indicator if no data is available
          if (state.status == HistoryStatus.loading && state.history.isEmpty) {
            return const FullScreenLoadingWidget();
          }

          // Display error message if data is not available
          if (state.status == HistoryStatus.error) {
            return Center(
              child: Text(state.error),
            );
          }

          // Display List of donations and allowances in descending date order
          return Stack(
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
                      ),
                    );
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
                  endIndent: 0,
                  indent: 0,
                ),
              ),

              // Overlay loading indicator on top of list when loading (more) data
              if (state.status == HistoryStatus.loading &&
                  state.history.isNotEmpty)
                const CustomCircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
