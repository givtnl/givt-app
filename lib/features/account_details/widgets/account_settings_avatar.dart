import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/pages/change_profile_avatar_bottom_sheet.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:path/path.dart' as p;

class AccountSettingsAvatar extends StatelessWidget {
  const AccountSettingsAvatar({
    required this.user,
    super.key,
  });

  final UserExt user;

  static String fileNameFromProfilePicture(String profilePicture) {
    if (profilePicture.isEmpty) {
      return '';
    }
    return p.basename(profilePicture);
  }

  bool get _isUsUser => Country.fromCode(user.country).isCreditCard;

  @override
  Widget build(BuildContext context) {
    if (!_isUsUser) {
      return FunIcon.userLarge(
        circleSize: 100,
        circleColor: FunTheme.of(context).secondary95,
      );
    }

    final fileName = fileNameFromProfilePicture(user.profilePicture);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => _openAvatarEditor(context),
            customBorder: const CircleBorder(),
            splashColor: Theme.of(context).primaryColor,
            child: fileName.isEmpty
                ? FunIcon.userLarge(circleSize: 100)
                : FunAvatar.hero(fileName, size: 100),
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
            onPressed: () => _openAvatarEditor(
              context,
              analyticsEvent: AnalyticsEventName.editAvatarIconClicked,
            ),
          ),
        ),
      ],
    );
  }

  void _openAvatarEditor(
    BuildContext context, {
    AnalyticsEventName analyticsEvent =
        AnalyticsEventName.editAvatarPictureClicked,
  }) {
    AnalyticsHelper.logEvent(eventName: analyticsEvent);
    ChangeProfileAvatarBottomSheet.show(
      context,
      currentProfilePicture: user.profilePicture,
    );
  }
}
