import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/gratitude_selection_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/guess_secret_word_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/gratitude_selection_widget.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class GratitudeSelectionScreen extends StatefulWidget {
  const GratitudeSelectionScreen({required this.reporter, super.key});

  final GameProfile reporter;

  @override
  State<GratitudeSelectionScreen> createState() =>
      _GratitudeSelectionScreenState();
}

class _GratitudeSelectionScreenState extends State<GratitudeSelectionScreen> {
  final cubit = getIt<GratitudeSelectionCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init(widget.reporter);
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: cubit,
      onData: (context, uiModel) {
        return GratitudeSelectionWidget(
            uimodel: uiModel,
            onClickTile: cubit.onClickTile,
            onNext: () => Navigator.pushReplacement(
                  context,
                  (uiModel.sideKick.roles.length > 1
                          ? const GuessSecretWordScreen()
                          : PassThePhone.toSidekick(
                              uiModel.sideKick,
                            ))
                      .toRoute(context),
            ));
      },
    );
  }
}
