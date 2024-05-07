import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ChatIconButton extends StatelessWidget {
  const ChatIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerosityChallengeCubit, GenerosityChallengeState>(
      builder: (BuildContext context, GenerosityChallengeState state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () async {
                context.goNamed(
                  Pages.generosityChallengeChat.name,
                  extra: context.read<GenerosityChallengeCubit>(),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.solidComments,
                color: AppTheme.givtGreen40,
              ),
            ),
            if (state.hasAvailableChat)
              const Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: AppTheme.error50,
                ),
              ),
          ],
        );
      },
    );
  }
}
