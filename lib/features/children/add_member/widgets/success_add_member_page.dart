import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/add_member/widgets/download_g4k_button.dart';
import 'package:givt_app/features/children/utils/cached_family_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:go_router/go_router.dart';

class AddMemeberSuccessPage extends StatelessWidget {
  const AddMemeberSuccessPage({
    required this.familyAlreadyExists,
    this.showAllowanceWarning = false,
    super.key,
  });
  final bool familyAlreadyExists;
  final bool showAllowanceWarning;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: familyAlreadyExists
                  ? '${context.l10n.membersAreAdded}\n'
                  : '${context.l10n.congratulationsKey}\n',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              children: [
                TextSpan(
                  text: '${context.l10n.downloadKey} ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: '${context.l10n.g4kKey} ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: context.l10n.childrenCanExperienceTheJoyOfGiving,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/vpc_success.svg',
            width: size.width * 0.8,
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DownloadG4KButton(),
              ),
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
