import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ParentAvatar extends StatelessWidget {
  const ParentAvatar({
    required this.firstName,
    required this.lastName,
    required this.pictureURL,
    super.key,
  });

  final String firstName;
  final String lastName;
  final String pictureURL;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.editAvatarPictureClicked,
                  );

                  context.pushNamed(FamilyPages.parentAvatarSelection.name);
                },
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColor,
                child: SvgPicture.network(
                  pictureURL,
                  width: 100,
                ),
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.pen,
                  size: 20,
                ),
                onPressed: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.editAvatarIconClicked,
                  );

                  context.pushNamed(FamilyPages.parentAvatarSelection.name);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '$firstName $lastName',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
