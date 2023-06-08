import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/models/webview_input.dart';

import 'package:givt_app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';

class GivingPage extends StatelessWidget {
  const GivingPage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const GivingPage(),
    );
  }

  Map<String, dynamic> _buildGivt(
    BuildContext context,
  ) {
    final giveBlocState = context.read<GiveBloc>().state;
    return WebViewInput(
      apiUrl: getIt<APIService>().apiURL,
      guid: (context.read<AuthCubit>().state as AuthSuccess).user.guid,
      organisation: giveBlocState.organisation.organisationName!,
      givtObj: GivtTransaction.toJsonList(giveBlocState.givtTransactions),
      confirmBtn: context.l10n.next,
      cancel: context.l10n.cancel,
      areYouSureToCancelGivts: context.l10n.areYouSureToCancelGivts,
      message: context.l10n.safariGivtTransaction,
      thanks: context.l10n.givtIsBeingProcessed(
        giveBlocState.organisation.organisationName.toString(),
      ),
      yesSuccess: context.l10n.yesSuccess,
      close: context.l10n.close,
      collect: context.l10n.collect,
    ).toJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: BlocConsumer<GiveBloc, GiveState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == GiveStatus.loading ||
              state.status == GiveStatus.error) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final givt = _buildGivt(context);
          return Center(
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
          );
        },
      ),
    );
  }
}
