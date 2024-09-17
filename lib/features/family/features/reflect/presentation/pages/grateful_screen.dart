import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class GratefulScreen extends StatefulWidget {
  const GratefulScreen({super.key});

  @override
  State<GratefulScreen> createState() => _GratefulScreenState();
}

class _GratefulScreenState extends State<GratefulScreen> {
  final _cubit = getIt<GratefulCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseStateConsumer(
        cubit: _cubit,
        onLoading: (context) =>
            const Center(child: CircularProgressIndicator()),
        onData: (context, uiModel) {
          return Column(
            children: [
              GratefulAvatarBar(
                uiModel: uiModel.avatarBarUIModel,
                onAvatarTapped: _cubit.onAvatarTapped,
              ),
              //TODO recommendations (pass uimodel.recommendationsUIModel)
              /*
              Recommendations(
                uiModel: uiModel.recommendationsUIModel,
                onRecommendationTapped: _cubit.onRecommendationTapped,
               */
            ],
          );
        },
      ),
    );
  }
}
