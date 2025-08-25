import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';

class TopupLoadingBottomSheet extends StatelessWidget {
  const TopupLoadingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentProfile = context.read<ProfilesCubit>().state.activeProfile;

    return FunBottomSheet(
      title: 'Top up ${currentProfile.possessiveName} wallet',
      icon: const CustomCircularProgressIndicator(),
      content: const Column(
        children: [
          BodyMediumText(
            "We're processing your top up",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
