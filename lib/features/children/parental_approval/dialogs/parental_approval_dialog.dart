import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/parental_approval/cubit/parental_approval_cubit.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_approved_page.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_confirmation_page.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_declined_page.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_error_page.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_loading_page.dart';
import 'package:go_router/go_router.dart';

class ParentalApprovalDialog extends StatelessWidget {
  const ParentalApprovalDialog({
    required this.donation,
    super.key,
  });

  final ChildDonation donation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (_) => ParentalApprovalCubit(
        donation: donation,
        decisionRepository: getIt(),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 7,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: BlocConsumer<ParentalApprovalCubit, ParentalApprovalState>(
                listener: (context, state) {
                  if (state.status == DecisionStatus.pop) {
                    context.pop(state.decisionMade);
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
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
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
