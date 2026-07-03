import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/features/pledges/manage/widgets/pledge_amount_editor_sheet.dart';
import 'package:givt_app/features/pledges/manage/widgets/pledge_frequency_editor_sheet.dart';
import 'package:givt_app/features/pledges/manage/widgets/pledge_giving_method_editor_sheet.dart';
import 'package:givt_app/features/pledges/manage/widgets/pledge_manage_list.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class PledgeManagePage extends StatefulWidget {
  const PledgeManagePage({
    required this.pledgeGroupId,
    super.key,
  });

  final String pledgeGroupId;

  @override
  State<PledgeManagePage> createState() => _PledgeManagePageState();
}

class _PledgeManagePageState extends State<PledgeManagePage> {
  late final PledgeManageCubit _cubit;

  void _popWithResult() {
    context.pop(_cubit.hasUpdates);
  }

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PledgeManageCubit>();
    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.pledgesManageOpened,
      eventProperties: {'pledge_group_id': widget.pledgeGroupId},
    );
    _cubit.init(widget.pledgeGroupId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<PledgeManageUIModel, PledgeManageCustom>(
      cubit: _cubit,
      onCustom: (context, custom) {
        final uiModel = _cubit.currentUIModel;
        if (uiModel == null) {
          return;
        }

        switch (custom) {
          case ShowAmountEditor(:final goal):
            PledgeAmountEditorSheet.show(
              context,
              cubit: _cubit,
              uiModel: uiModel,
              goal: goal,
            );
          case ShowFrequencyEditor():
            PledgeFrequencyEditorSheet.show(
              context,
              cubit: _cubit,
              uiModel: uiModel,
            );
          case ShowGivingMethodEditor():
            PledgeGivingMethodEditorSheet.show(
              context,
              cubit: _cubit,
              uiModel: uiModel,
            );
          case ManageUpdateSucceeded():
            _showSuccessSnackBar(context);
          case ManageUpdateFailed():
            _showErrorSnackBar(context);
        }
      },
      onData: (context, uiModel) {
        final locale = Localizations.localeOf(context).toLanguageTag();
        final countryCode = context.read<AuthCubit>().state.user.country;

        return FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            leading: GivtBackButtonFlat(
              onPressed: () async => _popWithResult(),
            ),
            title: context.l10n.pledgesManageTitle,
          ),
          body: SingleChildScrollView(
            child: PledgeManageList(
              uiModel: uiModel,
              countryCode: countryCode,
              locale: locale,
              onFieldPressed: _cubit.onManageFieldPressed,
            ),
          ),
        );
      },
      onLoading: (context) => FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: GivtBackButtonFlat(
            onPressed: () async => _popWithResult(),
          ),
          title: context.l10n.pledgesManageTitle,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      onError: (context, error) {
        final locals = context.l10n;
        return FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            leading: GivtBackButtonFlat(
              onPressed: () async => _popWithResult(),
            ),
            title: locals.pledgesManageTitle,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: FamilyAppTheme.error80,
                ),
                const SizedBox(height: 16),
                TitleMediumText(
                  locals.somethingWentWrong,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.pledgesEditUpdateSucceeded)),
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.somethingWentWrong)),
    );
  }
}
