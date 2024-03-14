import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/edit_payment_details/widgets/edit_credit_card_details_failure.dart';
import 'package:givt_app/features/edit_payment_details/widgets/edit_credit_card_details_success.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class EditPaymentDetailsConfirmationDialog extends StatefulWidget {
  const EditPaymentDetailsConfirmationDialog({
    required this.isSuccess,
    super.key,
  });

  final bool isSuccess;

  @override
  State<EditPaymentDetailsConfirmationDialog> createState() =>
      _EditPaymentDetailsConfirmationDialogState();
}

class _EditPaymentDetailsConfirmationDialogState
    extends State<EditPaymentDetailsConfirmationDialog> {
  static const Duration _autoCloseDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      _autoCloseDelay,
      () {
        if (mounted) {
          context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox.square(
        dimension: size.width * 0.8,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.white,
          elevation: 7,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: widget.isSuccess
                      ? const EditCardDetailsSuccess()
                      : const EditCardDetailsFailure(),
                ),
              ),
              Positioned(
                top: 7,
                right: 7,
                child: GestureDetector(
                  onTap: () {
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents
                          .editPaymentDetailsConfirmationDialogClosed,
                    );
                    context.pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: SvgPicture.asset(
                      'assets/images/close_icon.svg',
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
