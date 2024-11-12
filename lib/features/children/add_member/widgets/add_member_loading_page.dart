import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';

class AddMemberLoadingPage extends StatelessWidget {
  const AddMemberLoadingPage({super.key});

  void _navigateToProfileSelection(BuildContext context) {
    while (context.canPop()) {
      context.pop();
    }
    context.goNamed(FamilyPages.profileSelection.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddMemberCubit>(),
      child: BlocListener<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
          if (state.status == AddMemberStateStatus.success) {
            _navigateToProfileSelection(context);
          } else if (state.status == AddMemberStateStatus.error ||
              state.status == AddMemberStateStatus.topupFailed) {
            _navigateToProfileSelection(context);
            SnackBarHelper.showMessage(context, text: state.error);
          } else if (state.status == AddMemberStateStatus.successCached) {
            _navigateToProfileSelection(context);
          } else {
            _navigateToProfileSelection(context);
          }
        },
        child: const FunScaffold(
          body: SettingUpFamilySpaceLoadingWidget(),
        ),
      ),
    );
  }
}
