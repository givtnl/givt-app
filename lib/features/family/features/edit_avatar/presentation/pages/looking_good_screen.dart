import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class LookingGoodScreen extends StatefulWidget {
  const LookingGoodScreen({required this.uiModel, super.key});

  final LookingGoodUIModel uiModel;

  @override
  State<LookingGoodScreen> createState() => _LookingGoodScreenState();
}

class _LookingGoodScreenState extends State<LookingGoodScreen> {
  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _showAvatarCard(
              'Looking good\n${widget.uiModel.userFirstName}!',
            ),
            const Spacer(),
            FunButton(
              onTap: () {
                ScreenshotController()
                    .captureFromWidget(
                  context: context,
                  delay: const Duration(milliseconds: 50),
                  _showAvatarCard(
                    'Check out ${widget.uiModel.possessiveFirstName} superhero avatar',
                    share: true,
                  ),
                )
                    .then((capturedImage) {
                  Share.shareXFiles(
                    [
                      XFile.fromData(
                        capturedImage,
                        name: 'avatar.png',
                        mimeType: 'image/png',
                      )
                    ],
                    text:
                        'Head to the Givt app to create your own superhero and spread generosity!\ndownload.givt.com',
                  );
                });
              },
              text: 'Share',
              analyticsEvent:
                  AnalyticsEvent(AmplitudeEvents.shareAvatarClicked),
            ),
            const SizedBox(height: 16),
            FunButton.secondary(
              onTap: () {
                ConfettiDialog.show(context);
                Future.delayed(const Duration(milliseconds: 1500), () {
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                });
              },
              text: 'Done',
              analyticsEvent: AnalyticsEvent(AmplitudeEvents.continueClicked),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showAvatarCard(String text, {bool share = false}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: share ? 4 : 0),
            child: ClipRRect(
              child: Image.asset(
                  'assets/family/images/looking_good_background.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  width: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
            ),
            child: ClipRRect(
              child: widget.uiModel.avatar != null
                  ? SvgPicture.asset(
                      'assets/family/images/avatar/default/${widget.uiModel.avatar}',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    )
                  : widget.uiModel.customAvatarUIModel != null
                      ? Stack(
                          children: FunAvatar.customAvatarWidgetsList(
                            widget.uiModel.customAvatarUIModel!,
                          ),
                        )
                      : FunAvatar.defaultHero(),
            ),
          ),
          ClipRRect(
            child: SvgPicture.asset(
              share
                  ? 'assets/family/images/looking_good_share_frame.svg'
                  : 'assets/family/images/looking_good_frame.svg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              width: 300,
            ),
          ),
          Positioned(
            bottom: share ? 52 : 20,
            left: 16,
            right: 16,
            child: TitleMediumText(
              text,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
