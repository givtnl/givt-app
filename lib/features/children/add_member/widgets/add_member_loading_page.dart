import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class AddMemberLoadingPage extends StatelessWidget {
  const AddMemberLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddMemberCubit>(),
      child: BlocListener<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
          // TODO: KIDS-1274, caching members, errors and others
          if (state.status == AddMemberStateStatus.success) {
            Navigator.of(context).popUntil(
              (route) =>
                  FamilyPages.profileSelection.name == route.settings.name,
            );
          } else if (state.status == AddMemberStateStatus.error) {
            Navigator.of(context).popUntil(
              (route) =>
                  FamilyPages.profileSelection.name == route.settings.name,
            );
            SnackBarHelper.showMessage(context, text: state.error);
          } else {
            Navigator.of(context).popUntil(
              (route) =>
                  FamilyPages.profileSelection.name == route.settings.name,
            );
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
