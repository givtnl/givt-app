import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/utils/auth_utils.dart';
import 'package:go_router/go_router.dart';

/// Shows a cautionary dialog when donation submission timed out.
class DonationSubmissionTimeoutDialog {
  static Future<void> show(BuildContext context) {
    final locals = context.l10n;

    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Semantics(
          namesRoute: true,
          label: locals.donationSubmissionTimeoutTitle,
          child: CupertinoAlertDialog(
            title: Text(locals.donationSubmissionTimeoutTitle),
            content: Text(locals.donationSubmissionTimeoutMessage),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<RemoteDataSourceSyncBloc>().add(
                        const RemoteDataSourceSyncRequested(),
                      );
                  AuthUtils.checkToken(
                    context,
                    checkAuthRequest: CheckAuthRequest(
                      navigate: (navContext) async {
                        navContext.goNamed(Pages.donationOverview.name);
                      },
                    ),
                  );
                },
                child: Text(locals.donationSubmissionTimeoutCheckHistoryButton),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.goNamed(Pages.home.name);
                },
                child: Text(locals.flowGenericErrorGoToHome),
              ),
            ],
          ),
        );
      },
    );
  }
}
