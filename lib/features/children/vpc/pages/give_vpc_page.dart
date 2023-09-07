import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/routes/route_utils.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/models/vps_response.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_intro_page.dart';
import 'package:givt_app/features/children/vpc/pages/vpc_success_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class GiveVPCPage extends StatelessWidget {
  const GiveVPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);

    return Scaffold(
      body: BlocConsumer<VPCCubit, VPCState>(
        listener: (context, state) {
          log('vpc state changed on $state');
          if (state is VPCErrorState || state is VPCCanceledState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  locals.vpcErrorText,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
            context.read<VPCCubit>().resetVPC();
            context.goNamed(Pages.childrenOverview.name);
          }
        },
        builder: (context, state) {
          if (state is VPCInfoState) {
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
  return Container(
    width: double.infinity,
    height: double.infinity,
    margin: const EdgeInsets.only(top: 30),
    child: InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(response.url)),
      onWebViewCreated: (controller) {
        controller.loadUrl(
          urlRequest: URLRequest(url: Uri.parse(response.url)),
        );
      },
      onLoadStart: (controller, url) {
        log('VPC onLoadStart: $url');
        if (url == Uri.parse(response.cancelUrl)) {
          context.read<VPCCubit>().redirectOnCancel();
        } else if (url == Uri.parse(response.successUrl)) {
          context.read<VPCCubit>().redirectOnSuccess();
        }
      },
    ),
  );
}
