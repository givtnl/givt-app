import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class TopupLoadingBottomSheet extends StatelessWidget {
  const TopupLoadingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    return FunBottomSheet(
      title: 'Top up ${user.possessiveName} wallet',
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
