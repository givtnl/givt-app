import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AllowancesWarningDialog extends StatelessWidget {
  const AllowancesWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/wallet.svg',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          Text(
            'Almost done...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'We had trouble getting money from your account for the giving allowance(s).',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'No worries, we will try again tomorrow!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Color(0xFF617793)),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(bottom: 24),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF60DD9B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(0xFF005231),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
