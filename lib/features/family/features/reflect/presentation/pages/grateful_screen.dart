import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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
      appBar: FunTopAppBar(
        title: "You're grateful for",
        actions: [
          GestureDetector(
            onTap: () => _navigateToSummary(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: FaIcon(
                FontAwesomeIcons.xmark,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: _handleCustom,
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

  void _handleCustom(BuildContext context, GratefulCustom custom) {
    switch (custom) {
      case final GratefulOpenKidDonationFlow data:
        // TODO: Handle this case.
        data.organisation;
        break;
      case final GratefulOpenParentDonationFlow data:
        // TODO: Handle this case.
        data.profile;
        break;
      case GratefulGoToGameSummary():
        _navigateToSummary(context);
    }
  }

  void _navigateToSummary(BuildContext context) {
    Navigator.of(context).push(const SummaryScreen().toRoute(context));
  }
}
