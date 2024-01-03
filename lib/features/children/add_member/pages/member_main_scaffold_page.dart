import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_form_page.dart';
import 'package:givt_app/features/children/add_member/pages/success_add_member_page.dart';
import 'package:givt_app/features/children/add_member/pages/vpc_page.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AddMemeberMainScaffold extends StatelessWidget {
  const AddMemeberMainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        if (state.status == AddMemberStateStatus.error) {
          SnackBarHelper.showMessage(
            context,
            text: state.error,
            isError: true,
          );
          context.goNamed(Pages.childrenOverview.name);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                if (state.status == AddMemberStateStatus.vpc) {
                  context.read<AddMemberCubit>().goToInput();
                  return;
                }
                context.pop();
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.backClicked,
                );
              },
            ),
          ),
          body: SafeArea(
            child: _createPage(state, context),
          ),
        );
      },
    );
  }
}

Widget _createPage(AddMemberState state, BuildContext context) {
  switch (state.status) {
    case AddMemberStateStatus.vpc:
      return const VPCPage();
    case AddMemberStateStatus.input:
    case AddMemberStateStatus.initial:
    case AddMemberStateStatus.error:
      return const CreateMemberPage();
    case AddMemberStateStatus.success:
      return const AddMemeberSuccessPage();
    case AddMemberStateStatus.loading:
      return const Center(child: CircularProgressIndicator.adaptive());
  }
}
