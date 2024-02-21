import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_amount_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_cause_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_confirmation_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_confirmed_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_loading_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_overview_page.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class CreateFamilyGoalFlowPage extends StatelessWidget {
  const CreateFamilyGoalFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateFamilyGoalCubit, CreateFamilyGoalState>(
      listener: (context, state) {
        if (state.status == FamilyGoalCreationStatus.confirmation &&
            state.error.isNotEmpty) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case FamilyGoalCreationStatus.overview:
            return const CreateFamilyGoalOverviewPage();
          case FamilyGoalCreationStatus.cause:
            return const CreateFamilyGoalCausePage();
          case FamilyGoalCreationStatus.amount:
            return const CreateFamilyGoalAmountPage();
          case FamilyGoalCreationStatus.confirmation:
            return CreateFamilyGoalConfirmationPage(state: state);
          case FamilyGoalCreationStatus.loading:
            return CreateFamilyGoalLoadingPage(state: state);
          case FamilyGoalCreationStatus.confirmed:
            return CreateFamilyGoalConfirmedPage(state: state);
        }
      },
    );
  }
}
