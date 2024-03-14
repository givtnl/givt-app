import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/edit_payment_details/cubit/edit_stripe_cubit.dart';
import 'package:givt_app/features/edit_payment_details/dialogs/edit_payment_details_confirmation_dialog.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class EditCreditCardDetailsPage extends StatelessWidget {
  const EditCreditCardDetailsPage({super.key});

  void _showConfirmationDialog(BuildContext context, bool isSuccess) {
    showDialog<void>(
      context: context,
      builder: (context) => EditPaymentDetailsConfirmationDialog(
        isSuccess: isSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EditStripeCubit, EditStripeState>(
        listener: (BuildContext context, EditStripeState state) {
          if (state.stripeStatus == StripeObjectStatus.success) {
            context.pop();

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.editPaymentDetailsSuccess,
            );

            _showConfirmationDialog(context, true);
            context.read<AuthCubit>().refreshUser();
          } else if (state.stripeStatus == StripeObjectStatus.failure) {
            context.pop();

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.editPaymentDetailsFailure,
            );

            _showConfirmationDialog(context, false);
          } else if (state.stripeStatus == StripeObjectStatus.canceled) {
            context.pop();

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.editPaymentDetailsCanceled,
            );

            SnackBarHelper.showMessage(
              // ignore: use_build_context_synchronously
              context,
              text: context.l10n.editPaymentDetailsCanceled,
            );
          }
        },
        builder: (context, state) {
          final response = state.stripeObject;

          if (state.stripeStatus == StripeObjectStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return state.stripeStatus != StripeObjectStatus.display
              ? const SizedBox()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(response.url),
                      ),
                      onWebViewCreated: (controller) {
                        controller.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse(response.url),
                          ),
                        );
                      },
                      onLoadStart: (controller, url) {
                        if (url == Uri.parse(response.cancelUrl)) {
                          context
                              .read<EditStripeCubit>()
                              .stripeUpdateCanceled();
                        } else if (url == Uri.parse(response.successUrl)) {
                          context
                              .read<EditStripeCubit>()
                              .stripeUpdateComplete();
                        }
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
