import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
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
                  context.pushNamed(Pages.avatarSelection.name);
                },
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColor,
                child: SvgPicture.network(
                  pictureURL,
                  width: 150,
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: -5,
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.pen,
                  size: 25,
                ),
                onPressed: () {
                  context.pushNamed(Pages.avatarSelection.name);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '$firstName $lastName',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
