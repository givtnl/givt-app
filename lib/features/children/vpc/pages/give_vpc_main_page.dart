import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_single_page.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_success_page.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_web_view_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GiveVPCMainPage extends StatelessWidget {
  const GiveVPCMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VPCCubit, VPCState>(
      listener: (context, state) {
        if (state is VPCErrorState || state is VPCCanceledState) {
          SnackBarHelper.showMessage(
            context,
            text: context.l10n.vpcErrorText,
            isError: true,
          );
          context.read<VPCCubit>().resetVPC();
          context.goNamed(Pages.childrenOverview.name);
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
            child: _createVpcPage(state),
          ),
        );
      },
    );
  }
}

Widget _createVpcPage(VPCState state) {
  if (state is VPCInfoState) {
    return const VPCSinglePage();
  } else if (state is VPCFetchingURLState) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is VPCSuccessState) {
    return const VPCSuccessPage();
  } else if (state is VPCWebViewState) {
    return VPCWebViewPage(response: state.response);
  } else {
    return Container();
  }
}
