import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/utils.dart';

class AvatarItem extends StatelessWidget {
  const AvatarItem({
    required this.url,
    required this.filename,
    required this.isSelected,
    this.onSelectProfilePicture,
    super.key,
  });

  final String url;
  final String filename;
  final bool isSelected;
  final void Function(String profilePicture)? onSelectProfilePicture;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {
          SystemSound.play(SystemSoundType.click);
          onSelectProfilePicture?.call(filename);
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.avatarImageSelected,
            eventProperties: {
              AnalyticsHelper.avatarImageKey: filename,
            },
          );
        },
        customBorder: const CircleBorder(),
        splashColor: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            SvgPicture.network(url),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 6,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
