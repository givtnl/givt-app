import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/models/vps_response.dart';

class VPCWebViewPage extends StatelessWidget {
  const VPCWebViewPage({
    required this.response,
    super.key,
  });

  final VPCResponse response;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(response.url)),
        onWebViewCreated: (controller) {
          controller.loadUrl(
            urlRequest: URLRequest(url: Uri.parse(response.url)),
          );
        },
        onLoadStart: (controller, url) {
          if (url == Uri.parse(response.cancelUrl)) {
            context.read<VPCCubit>().redirectOnCancel();
          } else if (url == Uri.parse(response.successUrl)) {
            context.read<VPCCubit>().redirectOnSuccess();
          }
        },
      ),
    );
  }
}
