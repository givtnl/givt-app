import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/family/features/family_history/models/donation.dart';
import 'package:givt_app/features/family/features/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/features/parental_approval/cubit/parental_approval_cubit.dart';
import 'package:givt_app/features/family/features/parental_approval/widgets/parental_approval_approved_page.dart';
import 'package:givt_app/features/family/features/parental_approval/widgets/parental_approval_confirmation_page.dart';
import 'package:givt_app/features/family/features/parental_approval/widgets/parental_approval_declined_page.dart';
import 'package:givt_app/features/family/features/parental_approval/widgets/parental_approval_error_page.dart';
import 'package:givt_app/features/family/features/parental_approval/widgets/parental_approval_loading_page.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ParentalApprovalDialogContent extends StatelessWidget {
  const ParentalApprovalDialogContent({
    required this.donation,
    super.key,
  });

  final Donation donation;

  Future<void> _refreshHistory(BuildContext context) async {
    await context.read<FamilyOverviewCubit>().refresh();
    if (!context.mounted) return;

    // Exectue the following cubits in parallel
    await Future.wait([
      context.read<FamilyHistoryCubit>().fetchHistory(fromScratch: true),
      context.read<ImpactGroupsCubit>().refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentalApprovalCubit, ParentalApprovalState>(
      listener: (context, state) async {
        if (state.status == DecisionStatus.approved ||
            state.status == DecisionStatus.declined) {
          await _refreshHistory(context);
        } else if (state.status == DecisionStatus.pop) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _createPage(state.status),
              ),
            ),
            if (state.status != DecisionStatus.loading &&
                state.status != DecisionStatus.pop)
              Positioned(
                top: 7,
                right: 7,
                child: GestureDetector(
                  onTap: () {
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.pendingDonationCloseClicked,
                    );
                    context.pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: SvgPicture.asset(
                      'assets/images/close_icon.svg',
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _createPage(DecisionStatus status) {
    switch (status) {
      case DecisionStatus.confirmation:
        return ParentalApprovalConfirmationPage(
          donation: donation,
        );
      case DecisionStatus.loading:
        return const ParentalApprovalLoadingPage();
      case DecisionStatus.approved:
        return ParentalApprovalApprovedPage(
          donation: donation,
        );
      case DecisionStatus.declined:
        return ParentalApprovalDeclinedPage(
          donation: donation,
        );
      case DecisionStatus.error:
        return const ParentalApprovalErrorPage();
      case DecisionStatus.pop:
        return Container();
    }
  }
}
