import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_single_page.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_success_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GiveVPCMainPage extends StatelessWidget {
  const GiveVPCMainPage({super.key});

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
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                context.pop();
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.backClicked,
                );
              },
            ),
          ),
          body: SafeArea(
            child: _createPage(state),
          ),
        );
      },
    );
  }
}

Widget _createPage(AddMemberState state) {
  if (state is VPCInfoState) {
    return const VPCSinglePage();
  } else if (state is VPCSuccessState) {
    return const VPCSuccessPage();
  } else {
    return Container();
  }
}
