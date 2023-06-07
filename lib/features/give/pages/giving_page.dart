import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';

import 'package:givt_app/features/give/pages/home_page.dart';
import 'package:givt_app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Center(
        child: InAppWebView(
          initialUserScripts: UnmodifiableListView(
            [
              UserScript(
                source: '''
                  window.addEventListener('flutterInAppWebViewPlatformReady', function(event) {
                    // window.document.getElementById('cancelBtn').onclick = null;
                    // window.document.getElementById('cancelBtn').onclick = function (event) {
                    //   window.flutter_inappwebview.callHandler('navigate', ['cancel'])
                    // };
                    if (window.document.getElementById('button').innerHTML != 'Close') {
                      return;
                    }
                      window.document.getElementById('button').onclick = null;
                      window.document.getElementById('button').onclick = function (event) {
                        window.flutter_inappwebview.callHandler('navigate', ['success'])
                      };
                  });
                ''',
                injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
              )
            ],
          ),
          onLoadStop: (controller, url) async {
            if (!url.toString().contains('success')) {
              return;
            }
            controller.addJavaScriptHandler(
              handlerName: 'navigate',
              callback: (args) {
                if (!args.first.toString().contains('success')) {
                  return;
                }
                Navigator.of(context).popUntil((route) => route is HomePage);
              },
            );
          },
          contextMenu: ContextMenu(
            options: ContextMenuOptions(
              hideDefaultSystemContextMenuItems: true,
            ),
          ),
          initialUrlRequest: URLRequest(
            url: Uri.https(
              getIt<APIService>().apiURL,
              'confirm.html',
              {'msg': base64.encode(utf8.encode(jsonEncode(givt)))},
            ),
          ),
        ),
      ),
    );
  }
}
