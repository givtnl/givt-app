import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/utils/utils.dart';

class CachedMemberOverviewTile extends StatelessWidget {
  const CachedMemberOverviewTile({
    required this.member,
    super.key,
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: _getBorderColor(context),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(width: 2, color: _getBorderColor(context)),
          backgroundColor: _getBackgroundColor(context),
        ),
        onPressed: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SvgPicture.asset(
                'assets/images/default_hero.svg',
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.firstName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    color: AppTheme.givtBlue,
                  ),
            ),
            if (member.isChild)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  //TODO: POEditor
                  'Waiting...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.givtBlue,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (member.isAdult) {
      return AppTheme.givtLightBackgroundBlue;
    }
    if (member.isChild) {
      return AppTheme.givtLightBackgroundGreen;
    }
    return Theme.of(context).colorScheme.error;
  }

  Color _getBorderColor(BuildContext context) {
    if (member.isAdult) {
      return AppTheme.givtDisabledBorderBlue;
    }
    if (member.isChild) {
      return AppTheme.givtDisabledBorderGreen;
    }
    return Theme.of(context).colorScheme.onError;
  }
}
