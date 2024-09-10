import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_amount_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_cause_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_confirmation_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_confirmed_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_loading_page.dart';
import 'package:givt_app/features/children/family_goal/pages/create_family_goal_overview_page.dart';
import 'package:givt_app/shared/bloc/organisation/organisation.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class CreateFamilyGoalFlowPage extends StatelessWidget {
  const CreateFamilyGoalFlowPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: BlocBuilder<OrganisationBloc, OrganisationState>(
        builder: (BuildContext context, OrganisationState orgState) {
          return BlocConsumer<CreateFamilyGoalCubit, CreateFamilyGoalState>(
            listener: (context, state) {
              if (state.error.isNotEmpty) {
                SnackBarHelper.showMessage(
                  context,
                  text: state.error,
                  isError: true,
                );
              }
            },
            builder: (context, createGoalState) {
              if (orgState.status == OrganisationStatus.loading) {
                return const CreateFamilyGoalLoadingPage(
                  stepperStatus: FamilyGoalCreationStatus.overview,
                );
              }
              switch (createGoalState.status) {
                case FamilyGoalCreationStatus.overview:
                  return const CreateFamilyGoalOverviewPage();
                case FamilyGoalCreationStatus.cause:
                  return const CreateFamilyGoalCausePage();
                case FamilyGoalCreationStatus.amount:
                  return CreateFamilyGoalAmountPage(
                    amount: createGoalState.amount,
                  );
                case FamilyGoalCreationStatus.confirmation:
                  return CreateFamilyGoalConfirmationPage(
                      state: createGoalState);
                case FamilyGoalCreationStatus.loading:
                  return const CreateFamilyGoalLoadingPage(
                    stepperStatus: FamilyGoalCreationStatus.confirmation,
                  );
                case FamilyGoalCreationStatus.confirmed:
                  return CreateFamilyGoalConfirmedPage(state: createGoalState);
              }
            },
          );
        },
      ),
    );
  }
}
