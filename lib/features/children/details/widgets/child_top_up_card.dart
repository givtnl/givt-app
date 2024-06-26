import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class ChildTopUpCard extends StatelessWidget {
  const ChildTopUpCard({
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppTheme.givtLightBackgroundGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              width: 2,
              color: AppTheme.childGivingAllowanceCardBorder,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              plusIcon(size: 40),
              const SizedBox(height: 10),
              Text(
                context.l10n.topUp,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppTheme.inputFieldBorderSelected,
                      fontFamily: 'Raleway',
                      height: 1.2,
                    ),
              ),
              Text(
                context.l10n.topUpCardInfo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppTheme.childGivingAllowanceHint,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
