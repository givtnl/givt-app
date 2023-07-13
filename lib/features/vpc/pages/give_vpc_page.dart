import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/vpc/models/vps_response.dart';
import 'package:givt_app/features/vpc/pages/vpc_intro_page.dart';
import 'package:givt_app/features/vpc/pages/vpc_success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GiveVPCPage extends StatelessWidget {
  const GiveVPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VPCCubit, VPCState>(
        listener: (context, state) {
          log('vpc state changed on $state');
          if (state is VPCErrorState || state is VPCCanceledState) {
            log(state.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Cannot get VPC. Please try again later.',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
            context.read<VPCCubit>().showProfiles();
          }
        },
        builder: (context, state) {
          if (state is VPCProfilesOverview) {
            return _createProfilesOverviewPage(context);
          } else if (state is VPCInfoState) {
            return const VPCIntroPage();
          } else if (state is VPCFetchingURLState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VPCSuccessState) {
            return const VPCSuccessPage();
            // } else if (state is VPCCanceledState) {
            //   return _createVPCCanceledPage(context);
          } else if (state is VPCWebViewState) {
            return _createWebViewPage(context, state.response);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

Widget _createWebViewPage(BuildContext context, VPCResponse response) {
  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          log('VPC onPageStarted: $url');
          if (url == response.cancelUrl) {
            context.read<VPCCubit>().redirectOnCancel();
          } else if (url == response.successUrl) {
            context.read<VPCCubit>().redirectOnSuccess();
          }
        },
      ),
    )
    ..loadRequest(Uri.parse(response.url));

  return Container(
    width: double.infinity,
    height: double.infinity,
    margin: const EdgeInsets.only(top: 30),
    child: WebViewWidget(controller: webViewController),
  );
}

Widget _createProfilesOverviewPage(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () => context.read<VPCCubit>().showVPCInfo(),
        child: const Text('CREATE PROFILE'),
      ),
    ),
  );
}
