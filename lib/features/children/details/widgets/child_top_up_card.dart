import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/utils/child_date_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class ChildTopUpCard extends StatelessWidget {
  const ChildTopUpCard({
    required this.profileDetails,
    this.onPressed,
    super.key,
  });

  final ProfileExt profileDetails;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final nextTopUpDate =
        DateTime.parse(profileDetails.givingAllowance.nextGivingAllowanceDate);

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
              const FaIcon(
                FontAwesomeIcons.plus,
                size: 40,
                color: AppTheme.givtLightGreen,
              ),
              const SizedBox(height: 10),
              Text(
                'Top Up',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppTheme.inputFieldBorderSelected,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
              ),
              Text(
                "Add a one-time amount to your\nchild's Wallet",
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
