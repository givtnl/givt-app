import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/vpc/models/vps_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GiveVPCPage extends StatelessWidget {
  const GiveVPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Give VPC [PLACEHOLDER]'),
        ),
        body: BlocConsumer<VPCCubit, VPCState>(
          listener: (context, state) {
            log('vpc state changed on $state');
            if (state is VPCErrorState) {
              log(state.error);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Cannot get VPC URL. Please try again later.',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VPCProfilesOverview) {
              return _createProfilesOverviewPage(context);
            } else if (state is VPCInfoState) {
              return _createVPCInfoPage(context);
            } else if (state is VPCFetchingURLState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VPCSuccessState) {
              return _createVPCSuccessPage(context);
            } else if (state is VPCCanceledState) {
              return _createVPCCanceledPage(context);
            } else if (state is VPCWebViewState) {
              return _createWebViewPage(context, state.response);
            } else {
              return Container();
            }
          },
        ),
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

  return SizedBox.expand(
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

Widget _createVPCInfoPage(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Lorem ipsum\nVPC INFO text',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () => context
                .read<VPCCubit>()
                .fetchURL(context.read<AuthCubit>().state.user.email),
            child: const Text('GIVE VPC'),
          ),
        ],
      ),
    ),
  );
}

Widget _createVPCSuccessPage(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'VPC: SUCCESS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('PROCEED WITH PROFILE'),
          ),
        ],
      ),
    ),
  );
}

Widget _createVPCCanceledPage(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'VPC: CANCELED',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () => context
                .read<VPCCubit>()
                .fetchURL(context.read<AuthCubit>().state.user.email),
            child: const Text('RETRY'),
          ),
        ],
      ),
    ),
  );
}
