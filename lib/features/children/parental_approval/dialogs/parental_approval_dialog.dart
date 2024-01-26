import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/parental_approval/cubit/parental_approval_cubit.dart';
import 'package:givt_app/features/children/parental_approval/widgets/parental_approval_dialog_content.dart';

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
      child: Center(
        child: SizedBox.square(
          dimension: size.width * 0.8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.white,
            elevation: 7,
            child: ParentalApprovalDialogContent(donation: donation),
          ),
        ),
      ),
    );
  }
}
