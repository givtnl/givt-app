import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';

class MayorChatDialog extends StatelessWidget {
  const MayorChatDialog({
    required this.onDismiss,
    required this.onGoToChat,
    this.isFirstDay = false,
    super.key,
  });
  final bool isFirstDay;
  final VoidCallback onDismiss;
  final VoidCallback onGoToChat;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  _buildMayorAvatarWithRedDot(),
                  if (!isFirstDay) _buildCloseButton(),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isFirstDay
                    ? 'Well done! A message\nfrom the Mayor'
                    : 'The Mayor Sent  a\nmessage',
                textAlign: TextAlign.center,
                style: chatCompletedTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: isFirstDay ? 8 : 0),
              if (isFirstDay) _buildRedDotExplanation(),
              const SizedBox(height: 16),
              GivtElevatedButton(
                onTap: onGoToChat,
                text: 'Go to Chat',
                rightIcon: FontAwesomeIcons.solidComments,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.topRight,
        onPressed: onDismiss,
        icon: const FaIcon(
          FontAwesomeIcons.xmark,
          color: AppTheme.primary20,
        ),
      ),
    );
  }

  Widget _buildMayorAvatarWithRedDot() {
    return Center(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/mayor_avatar.svg',
            height: 140,
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: AppTheme.error50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedDotExplanation() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Whenever I have a message for you a ',
            style: chatCompletedTextStyle,
          ),
          TextSpan(
            text: 'red dot',
            style: chatCompletedTextStyle.copyWith(
              color: AppTheme.error50,
            ),
          ),
          TextSpan(
            text: ' will appear in the top right corner',
            style: chatCompletedTextStyle,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  TextStyle get chatCompletedTextStyle => const TextStyle(
        color: Color(0xFF003920),
        fontSize: 18,
        fontFamily: 'Rouna',
        fontWeight: FontWeight.w500,
      );
}
