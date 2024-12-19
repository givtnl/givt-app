import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/game_summary/presentation/widgets/summary_page.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/parent_summary_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class ParentSummaryScreen extends StatefulWidget {
  const ParentSummaryScreen({super.key});

  @override
  State<ParentSummaryScreen> createState() => _ParentSummaryScreenState();
}

class _ParentSummaryScreenState extends State<ParentSummaryScreen> {
  final ParentSummaryCubit _cubit = getIt<ParentSummaryCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.secondary10,
      appBar: FunTopAppBar(
        color: FamilyAppTheme.secondary10,
        title: 'Summary',
        titleColor: Colors.white,
        leading: context.canPop()
            ? const GivtBackButtonFlat(
                color: Colors.white,
              )
            : null,
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, uiModel) {
          return uiModel != null
              ? SummaryPage(uiModel: uiModel)
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
