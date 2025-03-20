import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/dialogs/confetti_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

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
            Container(
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
                  ClipRRect(
                    child: Image.asset(
                      'assets/family/images/looking_good_background.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                    ),
                    child: ClipRRect(
                      child: SvgPicture.asset(
                        'assets/family/images/avatar/default/${widget.uiModel.avatar}',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  ClipRRect(
                    child: SvgPicture.asset(
                      'assets/family/images/looking_good_frame.svg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: TitleMediumText(
                      'Looking good\n${widget.uiModel.userFirstName}!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            FunButton(
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
}
