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
        if (state is AddMemberExternalErrorState) {
          SnackBarHelper.showMessage(
            context,
            text: state.errorMessage,
            isError: true,
          );
          context.pushReplacementNamed(Pages.childrenOverview.name);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                if (state is ConfirmVPCState && state.child != null) {
                  context.read<AddMemberCubit>().goToInput(child: state.child!);
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
  if (state is ConfirmVPCState) {
    return const VPCPage();
  } else if (state is AddMemberInputState || state is AddMemberInitial) {
    return const CreateMemberPage();
  } else if (state is AddMemberSuccessState) {
    return const AddMemeberSuccessPage();
  } else {
    return Container();
  }
}
