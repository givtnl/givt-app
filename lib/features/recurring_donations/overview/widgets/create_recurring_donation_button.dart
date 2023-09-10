import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class CreateRecurringDonationButton extends StatelessWidget {
  const CreateRecurringDonationButton({
    required this.onClick,
    super.key,
  });

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locals.recurringGiftsSetupCreate,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  locals.recurringGiftsSetupRecurringGift,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
