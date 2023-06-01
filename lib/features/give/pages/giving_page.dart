import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/bloc/give_bloc.dart';
import 'package:givt_app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GivingScreen extends StatelessWidget {
  const GivingScreen({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const GivingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<GiveBloc>().state;

    final locals = context.l10n;
    final givt = jsonDecode(state.givt);
    givt['ConfirmBtn'] = locals.next;
    givt['Cancel'] = locals.cancel;
    givt['AreYouSureToCancelGivts'] = locals.areYouSureToCancelGivts;
    givt['message'] = locals.safariGivtTransaction;
    givt['Thanks'] = locals
        .givtIsBeingProcessed(state.organisation.organisationName.toString());
    givt['YesSuccess'] = locals.yesSuccess;
    givt['Close'] = locals.close;
    givt['Collect'] = locals.collect;
    givt['apiUrl'] = getIt<APIService>().apiURL;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.https(
          getIt<APIService>().apiURL,
          'confirm.html',
          {'msg': base64.encode(utf8.encode(jsonEncode(givt)))},
        ),
      );
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Center(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
