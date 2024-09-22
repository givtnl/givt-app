import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_loading.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/recommendations_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

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
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onLoading: (context) => const GratefulLoading(),
      onData: (context, uiModel) {
        return FunScaffold(
          withSafeArea: false,
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
          body: Column(
            children: [
              GratefulAvatarBar(
                uiModel: uiModel.avatarBarUIModel,
                onAvatarTapped: (int i) async {
                  final userId = await _cubit.onAvatarTapped(i);
                  if (!context.mounted) return;
                  await context.read<ProfilesCubit>().setActiveProfile(userId);
                },
              ),
              Flexible(
                child: RecommendationsWidget(
                  uiModel: uiModel.recommendationsUIModel,
                  onRecommendationChosen: (int i) {
                    _cubit.onRecommendationChosen(i);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCustom(BuildContext context, GratefulCustom custom) {
    switch (custom) {
      case final GratefulOpenKidDonationFlow data:
        Navigator.of(context).push(
          BlocProvider(
            create: (BuildContext context) =>
                CreateTransactionCubit(context.read<ProfilesCubit>(), getIt()),
            child: ChooseAmountSliderScreen(
              onCustomSuccess: () {
                _cubit.onDonated(data.profile);
                context.pop();
              },
            ),
          ).toRoute(context),
        );
      case final GratefulOpenParentDonationFlow data:
        // TODO: Handle this case.
        data.profile;
      case GratefulGoToGameSummary():
        _navigateToSummary(context);
    }
  }

  void _navigateToSummary(BuildContext context) {
    Navigator.of(context).push(const SummaryScreen().toRoute(context));
  }
}
