import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/pages/failed_allowances_bottomsheet.dart';
import 'package:givt_app/features/children/add_member/pages/failed_vpc_bottomsheet.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class AddMemberLoadingPage extends StatelessWidget {
  const AddMemberLoadingPage({super.key});
  void _navigateToProfileSelection(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => FamilyPages.profileSelection.name == route.settings.name,
    );
  }

  void _navigateToProfileSelectionRefresh(BuildContext context) {
    Navigator.of(context)
      ..popUntil(
        (route) => FamilyPages.profileSelection.name == route.settings.name,
      )
      ..pop()
      ..pushNamed(FamilyPages.profileSelection.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddMemberCubit>(),
      child: BlocListener<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
          if (state.status == AddMemberStateStatus.success) {
            _navigateToProfileSelection(context);
          } else if (state.status == AddMemberStateStatus.error) {
            _navigateToProfileSelection(context);
            SnackBarHelper.showMessage(context, text: state.error);
          } else if (state.status == AddMemberStateStatus.successCached) {
            _navigateToProfileSelectionRefresh(context);
            VPCFailedCachedMembersBottomsheet.show(context, state.members);
          } else if (state.status == AddMemberStateStatus.successNoAllowances) {
            _navigateToProfileSelection(context);
            final walletAmount = state.members.fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.allowance ?? 0).toInt(),
            );
            InsufficientFundsBottomsheet.show(context, walletAmount);
          } else {
            _navigateToProfileSelection(context);
            SnackBarHelper.showMessage(
              context,
              text: state.status.toString(),
            );
          }
        },
        child: const FamilyScaffold(
          body: SettingUpFamilySpaceLoadingWidget(),
        ),
      ),
    );
  }
}
