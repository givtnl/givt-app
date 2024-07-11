import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';

class PictureAttachmentButtons extends StatelessWidget {
  const PictureAttachmentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GenerosityChallengeCubit>();
    return Column(
      children: [
        const SizedBox(height: 8),
        GivtElevatedButton(
          onTap: () => cubit.saveDay5Picture(
            takePhotoWithCamera: true,
          ),
          leftIcon: FontAwesomeIcons.camera,
          text: 'Take Picture',
        ),
        const SizedBox(height: 8),
        GivtElevatedSecondaryButton(
          onTap: () => cubit.saveDay5Picture(
            takePhotoWithCamera: false,
          ),
          leftIcon: const Icon(
            FontAwesomeIcons.image,
            size: 24,
            color: AppTheme.givtGreen40,
          ),
          text: 'Upload Picture',
        ),
      ],
    );
  }
}
