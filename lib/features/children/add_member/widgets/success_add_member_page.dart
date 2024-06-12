import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/utils/cached_family_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:go_router/go_router.dart';

class AddMemeberSuccessPage extends StatelessWidget {
  const AddMemeberSuccessPage(
      {required this.familyAlreadyExists,
      this.showAllowanceWarning = false,
      super.key});
  final bool familyAlreadyExists;
  final bool showAllowanceWarning;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/images/vpc_success.svg',
            width: size.width * 0.8,
          ),
          Column(
            children: [
              if (familyAlreadyExists)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomGreenElevatedButton(
                    title: context.l10n.seeMyFamily,
                    onPressed: () => context.pushReplacementNamed(
                      Pages.childrenOverview.name,
                      extra: showAllowanceWarning,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    if (CachedFamilyUtils.isFamilyCacheExist()) {
                      context.pushReplacementNamed(
                        Pages.cachedChildrenOverview.name,
                      );
                    } else {
                      context.pushReplacementNamed(
                        Pages.childrenOverview.name,
                        extra: showAllowanceWarning,
                      );
                    }
                  },
                  child: Text(
                    context.l10n.iWillDoThisLater,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}