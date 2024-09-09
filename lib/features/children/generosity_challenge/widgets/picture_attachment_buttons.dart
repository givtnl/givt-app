import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class PictureAttachmentButtons extends StatelessWidget {
  const PictureAttachmentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GenerosityChallengeCubit>();
    return Column(
      children: [
        const SizedBox(height: 8),
        FunButton(
          onTap: () => cubit.submitDay5Picture(
            takenWithCamera: true,
          ),
          leftIcon: FontAwesomeIcons.camera,
          text: 'Take Picture',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.generosityChallengeTakePictureClicked,
          ),
        ),
        const SizedBox(height: 8),
        FunButton.secondary(
          onTap: () {
            cubit.submitDay5Picture(
              takenWithCamera: false,
            );
          },
          leftIcon: FontAwesomeIcons.image,
          text: 'Upload Picture',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.generosityChallengeUploadPictureClicked,
          ),
        ),
      ],
    );
  }
}
